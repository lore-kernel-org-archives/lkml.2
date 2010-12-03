Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab0LCWNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 17:13:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52826 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557Ab0LCWNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 17:13:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Rolland <rol@as2917.net>
Subject: Re: [Bug #22542] [2.6.37-rc1] drm:i195 errors
Date: Fri, 3 Dec 2010 23:12:54 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc4+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <sKkKYVppECN.A.KhC.Phb5MB@chimera> <ATV3yiK8i4C.A.ynE.Rib5MB@chimera> <20101203224559.7e852abe@tux.DEF.witbe.net>
In-Reply-To: <20101203224559.7e852abe@tux.DEF.witbe.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012032312.54974.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 03, 2010, Paul Rolland wrote:
> Hello,
> 
> On Fri, 19 Nov 2010 00:42:44 +0100 (CET)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a summary
> > report of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.36.  Please verify if it still should be listed and let the
> > tracking team know (either way).
> 
> Still present in 2.6.27-rc4 :
> 
> Dec  3 21:31:32 tux kernel: [drm:intel_panel_get_max_backlight] *ERROR* fixme: max PWM is zero.
> Dec  3 21:31:32 tux kernel: [drm:intel_panel_get_max_backlight] *ERROR* fixme: max PWM is zero.
> Dec  3 21:41:32 tux kernel: [drm:intel_panel_get_max_backlight] *ERROR* fixme: max PWM is zero.
> Dec  3 21:41:32 tux kernel: [drm:intel_panel_get_max_backlight] *ERROR* fixme: max PWM is zero.
> Dec  3 22:41:18 tux kernel: [drm:intel_panel_get_max_backlight] *ERROR* fixme: max PWM is zero.

Thanks for the update.

Rafael
