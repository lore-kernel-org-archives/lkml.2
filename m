Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab1BYOMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 09:12:54 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:42487 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053Ab1BYOMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 09:12:52 -0500
Date: Fri, 25 Feb 2011 14:12:42 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Keng-Yu Lin <keng-yu.lin@canonical.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        tyson.chen@canonical.com, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] eeepc-wmi: set the touchpad toggle key code to F21
Message-ID: <20110225141242.GA20786@srcf.ucam.org>
References: <1298611140-21573-1-git-send-email-keng-yu.lin@canonical.com> <AANLkTim_JKQU9J3OJ0FRQ_ZVPktAPbnzr2t8SvhL2Uzj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim_JKQU9J3OJ0FRQ_ZVPktAPbnzr2t8SvhL2Uzj@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 07:52:11AM +0100, Corentin Chary wrote:

> Hum, I'm not very comfortable with this patch now that we got
> KEY_TOUCHPAD_TOGGLE.
> I know, it doesn't work with current Xorg, but if we continue to
> workaround that, it'll never be fixed.
> 
> Dmitry, Matthew, any advice ?

Yeah, I'd go with Dmitry's idea for now.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
