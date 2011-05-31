Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410Ab1EaIfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 04:35:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:55895 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256Ab1EaIfj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 04:35:39 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Subject: Re: [2.6.39] crash in acm_ctrl_msg+0x16/0x59
Date: Tue, 31 May 2011 10:37:46 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oliver Neukum <oliver@neukum.name>,
        "Greg Kroah-Hartman" <gregkh@suse.de>
References: <4DE25252.7050503@gmail.com> <4DE36118.4050706@gmail.com> <4DE3F0E6.6030507@gmail.com>
In-Reply-To: <4DE3F0E6.6030507@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105311037.46856.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 30. Mai 2011, 21:32:54 schrieb Riccardo Magliocchetti:
> >> So we are trying to talk to a device that is already gone.
> >> Is there anything unusual about your device? Could you
> >> post "lsusb -v"?
> >
> > Yes, the unusual thing is that is very prone to freezing when booting,
> > in fact it freezed when i got the crash in the laptop. Will post lsusb
> > output later in the day.
> 
> Here's the lsusb -v

There is something strange going on. This is a cdc-ether device.
Are you using any additional patches?

	Regards
		Oliver
-- 
- - - 
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg) 
Maxfeldstraße 5                         
90409 Nürnberg 
Germany 
- - - 
