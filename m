Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161068Ab1FAHch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 03:32:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:41771 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754918Ab1FAHcf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 03:32:35 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Subject: Re: [2.6.39] crash in acm_ctrl_msg+0x16/0x59
Date: Wed, 1 Jun 2011 09:34:45 +0200
User-Agent: KMail/1.13.5 (Linux/3.0.0-rc1-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oliver Neukum <oliver@neukum.name>,
        "Greg Kroah-Hartman" <gregkh@suse.de>
References: <4DE25252.7050503@gmail.com> <201105311037.46856.oneukum@suse.de> <4DE5E4C8.5060706@gmail.com>
In-Reply-To: <4DE5E4C8.5060706@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106010934.45691.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 1. Juni 2011, 09:05:44 schrieb Riccardo Magliocchetti:
> >> Here's the lsusb -v
> >
> > There is something strange going on. This is a cdc-ether device.
> > Are you using any additional patches?
> 
> I'm using a vanilla 2.6.39. I can get only lsusb when the phone is 
> booted and in that case it is recgnized as cdc-ether.
> 
> This is what i got when i attached the phone switched off like when i 
> got the crash:

Then please post lsusb -v of that state. This is a log of a connection
going wrong due to a bad cable or interference. Does that always happen?

	Regards
		Oliver
-- 
- - - 
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg) 
Maxfeldstraße 5                         
90409 Nürnberg 
Germany 
- - - 
