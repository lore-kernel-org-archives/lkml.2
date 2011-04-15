Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab1DOPRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 11:17:50 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:34591 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707Ab1DOPRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 11:17:49 -0400
From: Richard Weinberger <richard@nod.at>
To: James McMechan <james_mcmechan@hotmail.com>
Subject: Re: [uml-devel] gcc-4.6.0 generates no code for sub_preempt_count()
Date: Fri, 15 Apr 2011 17:17:42 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.25.20-0.7-pae; KDE/4.4.4; i686; ; )
Cc: mikpe@it.uu.se, linux-kernel@vger.kernel.org,
        uml devel <user-mode-linux-devel@lists.sourceforge.net>
References: <201104132150.05623.richard@nod.at> <201104141552.42213.richard@nod.at> <COL101-W165ED5CB17434202CE273DE2AD0@phx.gbl>
In-Reply-To: <COL101-W165ED5CB17434202CE273DE2AD0@phx.gbl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104151717.42534.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 14 April 2011, 21:50:13 schrieb James McMechan:
> > > > Any ideas whether this is a gcc or a kernel issue?
> 
> It looks like a gcc error with one of the optimization passes

I've submitted a bug report.

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=48623

Thanks,
//richard
