Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759081Ab2CMAm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:42:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33199 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759062Ab2CMAmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:42:25 -0400
Message-ID: <4F5E97EA.6030001@zytor.com>
Date: Mon, 12 Mar 2012 17:42:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Jan Kratochvil <jan.kratochvil@redhat.com>
CC: Denys Vlasenko <dvlasenk@redhat.com>,
        Roland McGrath <roland@hack.frob.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Kushal Das <kdas@redhat.com>
Subject: Re: Extending coredump note section to contain filenames
References: <4F5A3A4D.1020008@redhat.com> <20120309172934.GA18173@host2.jankratochvil.net> <4F5DE6A4.2030303@redhat.com> <20120312165359.GA32400@host2.jankratochvil.net> <4F5E76CE.4030601@zytor.com> <20120312223144.GA9636@host2.jankratochvil.net> <4F5E91DE.80609@zytor.com> <20120313002725.GA17828@host2.jankratochvil.net> <4F5E956F.3070108@zytor.com> <20120313003639.GA18427@host2.jankratochvil.net>
In-Reply-To: <20120313003639.GA18427@host2.jankratochvil.net>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2012 05:36 PM, Jan Kratochvil wrote:
> On Tue, 13 Mar 2012 01:31:43 +0100, H. Peter Anvin wrote:
>> This is basically providing the dso_list and executable information.
>> Several of the other things you list above (cmdline, environ, pid,
>> reason, maps) are already part of a core file.
> 
> dso_list and executable identification (their build-id) are also part of the
> core file.  It is only filesystem defect it can map filename -> content but it
> cannot map build-id -> content.  There are many indexing solutions for it,
> including slocate, when you have started to talk about not 100% reliable
> solutions.

There is no 100% reliable solution possible -- you have no guarantee of
any kind that the library executable still exists.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

