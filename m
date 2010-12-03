Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab0LCGyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 01:54:45 -0500
Received: from eazy.amigager.de ([213.239.192.238]:33489 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab0LCGyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 01:54:44 -0500
Date: Fri, 3 Dec 2010 07:55:15 +0100
From: Tino Keitel <tino.keitel@tikei.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #23462] DVI/EDID broken with Intel i945 graphics and
 2.6.37-rc2
Message-ID: <20101203065515.GA4414@mac.home>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	Florian Mickler <florian@mickler.org>
References: <1OMp3vU_qjP.A.JXG.uxC-MB@chimera>
 <gUkHV_Vc3aE.A.xzG.SyC-MB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gUkHV_Vc3aE.A.xzG.SyC-MB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 03, 2010 at 00:41:45 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.36.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=23462
> Subject		: DVI/EDID broken with Intel i945 graphics and 2.6.37-rc2
> Submitter	: Tino Keitel <tino.keitel@tikei.de>
> Date		: 2010-11-16 18:49 (17 days old)
> Message-ID	: <20101116184914.GA15794@mac.home>
> References	: http://marc.info/?l=linux-kernel&m=128993389113001&w=2


Hi,

this is fixed with 2.6.37-rc4-git2, works fine on my Mac mini.

Regards,
Tino
