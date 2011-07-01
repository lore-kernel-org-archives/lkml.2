Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab1GAOQH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 10:16:07 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:55179 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598Ab1GAOQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 10:16:06 -0400
Date: Fri, 1 Jul 2011 15:15:58 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: platform-driver-x86@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Corentin Chary <corentincj@iksaif.net>,
        "open list:ASUS NOTEBOOKS AN..." 
	<acpi4asus-user@lists.sourceforge.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/16] asus-wmi: Enable autorepeat for hotkey input
 device
Message-ID: <20110701141558.GB1363@srcf.ucam.org>
References: <1309512881-2901-1-git-send-email-corentin.chary@gmail.com>
 <1309512881-2901-5-git-send-email-corentin.chary@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309512881-2901-5-git-send-email-corentin.chary@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 11:34:29AM +0200, Corentin Chary wrote:
>  	asus->inputdev->id.bustype = BUS_HOST;
>  	asus->inputdev->dev.parent = &asus->platform_device->dev;
> +	__set_bit(EV_REP, asus->inputdev->evbit);

set_bit()? I guess it doesn't make much difference in this case, it just 
seems neater to use the non __ version.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
