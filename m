Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab2CMAQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:16:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33001 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756248Ab2CMAQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:16:40 -0400
Message-ID: <4F5E91DE.80609@zytor.com>
Date: Mon, 12 Mar 2012 17:16:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Jan Kratochvil <jan.kratochvil@redhat.com>
CC: Denys Vlasenko <dvlasenk@redhat.com>,
        Roland McGrath <roland@hack.frob.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Kushal Das <kdas@redhat.com>
Subject: Re: Extending coredump note section to contain filenames
References: <4F5A3A4D.1020008@redhat.com> <20120309172934.GA18173@host2.jankratochvil.net> <4F5DE6A4.2030303@redhat.com> <20120312165359.GA32400@host2.jankratochvil.net> <4F5E76CE.4030601@zytor.com> <20120312223144.GA9636@host2.jankratochvil.net>
In-Reply-To: <20120312223144.GA9636@host2.jankratochvil.net>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2012 03:31 PM, Jan Kratochvil wrote:
> On Mon, 12 Mar 2012 23:21:02 +0100, H. Peter Anvin wrote:
>> In particular, for libraries which aren't installed in standard system
>> directories (because they are test versions or mapped with dlopen()) it
>> would be good to have a hint of where to find them.  The build-id can
>> then tell you if you have the right version.
> 
> I believe "/proc/sys/kernel/core_pattern" was created so that Linux kernel
> does not have to contain code dumping of many associated info, the filenames
> seem to me to belong in this category.
> 

That's quite absurd if you think about it... we're talking about each
individual library, not necessarily the root binary.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

