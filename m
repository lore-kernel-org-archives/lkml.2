Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337Ab0JKU0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 16:26:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36105 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756312Ab0JKU0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 16:26:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: tim.gardner@canonical.com
Subject: Re: [Bug #16891] Kernel panic while loading intel module during boot
Date: Mon, 11 Oct 2010 22:25:05 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Anisse Astier <anisse@astier.eu>, Eric Anholt <eric@anholt.net>,
        Kees Cook <kees@canonical.com>
References: <pyPtebg28EI.A.ZPH.NvgsMB@chimera> <yeAD7A8RDxC.A.u6H.KwgsMB@chimera> <4CB2BA3F.4040208@canonical.com>
In-Reply-To: <4CB2BA3F.4040208@canonical.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010112225.05876.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 11, 2010, Tim Gardner wrote:
> On 10/10/2010 08:18 PM, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.34 and 2.6.35.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16891
> > Subject		: Kernel panic while loading intel module during boot
> > Submitter	: Anisse Astier<anisse@astier.eu>
> > Date		: 2010-08-24 13:19 (48 days old)
> >
> >
> 
> The original respondent (Kees Cook) assures me that the patch in 
> https://bugzilla.kernel.org/attachment.cgi?id=32602&action=edit does not 
> regress his platform.
> 
> Comment added to the bug report.

Thanks, changed status to 'resolved'.

Rafael
