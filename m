Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868Ab2CLWbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 18:31:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375Ab2CLWbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 18:31:50 -0400
Date: Mon, 12 Mar 2012 23:31:44 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Roland McGrath <roland@hack.frob.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Kushal Das <kdas@redhat.com>
Subject: Re: Extending coredump note section to contain filenames
Message-ID: <20120312223144.GA9636@host2.jankratochvil.net>
References: <4F5A3A4D.1020008@redhat.com>
 <20120309172934.GA18173@host2.jankratochvil.net>
 <4F5DE6A4.2030303@redhat.com>
 <20120312165359.GA32400@host2.jankratochvil.net>
 <4F5E76CE.4030601@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5E76CE.4030601@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2012 23:21:02 +0100, H. Peter Anvin wrote:
> In particular, for libraries which aren't installed in standard system
> directories (because they are test versions or mapped with dlopen()) it
> would be good to have a hint of where to find them.  The build-id can
> then tell you if you have the right version.

I believe "/proc/sys/kernel/core_pattern" was created so that Linux kernel
does not have to contain code dumping of many associated info, the filenames
seem to me to belong in this category.


Regards,
Jan
