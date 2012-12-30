Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab2L3Juy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 04:50:54 -0500
Received: from mail.skyhub.de ([78.46.96.112]:48961 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927Ab2L3Juw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 04:50:52 -0500
Date: Sun, 30 Dec 2012 10:50:54 +0100
From: Borislav Petkov <bp@alien8.de>
To: Richard Hartmann <richih.mailinglist@gmail.com>
Cc: ibm-acpi-devel@lists.sourceforge.net, ibm-acpi@hmh.eng.br,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] drivers/platform/x86/thinkpad_acpi.c: Handle HKEY event
 0x6040
Message-ID: <20121230095054.GB28308@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Richard Hartmann <richih.mailinglist@gmail.com>,
	ibm-acpi-devel@lists.sourceforge.net, ibm-acpi@hmh.eng.br,
	linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
References: <CAD77+gROUfVX=9LPZc6_jf=2Bc_iaf5FW5Z2efwESzORNrq9dQ@mail.gmail.com>
 <1356817910-20890-1-git-send-email-richih.mailinglist@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1356817910-20890-1-git-send-email-richih.mailinglist@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 29, 2012 at 10:51:49PM +0100, Richard Hartmann wrote:
> Handle HKEY event generated on AC power change. The current message
> asks users to submit data related to this event which leads to
> a lot of confusion and noise on the mailing list.
> 
> The following is a list affected models and 'Message-Id'
> from ibm-acpi-devel@lists.sourceforge.net of people who saw this
> event when either plugging or unplugging the AC adapter or
> docking or undocking their laptop.
> 
> X120e - CAAAujb5v9dHdbdxDVvhNJoG4UrZC1TgKqeB_zGpAy7q8kZHMEQ@mail.gmail.com
> X121e - 20120817143459.GB3462@x1.osrc.amd.com
> X220  - Confirmed by Richard Hartmann
> X220i - 4F406274.7070807@gmail.com
> X220t - 4F489F5B.9040705@cs.tu-berlin.de
> X230  - CAKx4u7kqvVH0-gstomsiVYdGC0i6=bGxzaQ8sq9gbg76TGme3w@mail.gmail.com
> T420  - 9c848ee30b006737d0534d906bab0cf6@niklaas-baudet.net
> T420s - 20120608080824.GS25324@hexapodia.org
> W520  - 20121008181050.GF2549@ericlaptop.home.christensenplace.us
> 
> Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>

Acked-by: Borislav Petkov <bp@alien8.de>

-- 
Regards/Gruss,
Boris.
