Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab1IORHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 13:07:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50591 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653Ab1IORHu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 13:07:50 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Sameer Nanda <snanda@chromium.org>
Subject: Re: RFC: Enable wakeup for intermediate USB bridge devices
Date: Thu, 15 Sep 2011 19:10:16 +0200
User-Agent: KMail/1.13.5 (Linux/3.1.0-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: stern@rowland.harvard.edu, gregkh@suse.de, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vincent Palatin <vpalatin@chromium.org>,
        olofj@chromium.org
References: <CANMivWbGTS_Xyj4MtgrYTWTkCbVKP_Uf-i-_hNYFx+YAPaNxjQ@mail.gmail.com>
In-Reply-To: <CANMivWbGTS_Xyj4MtgrYTWTkCbVKP_Uf-i-_hNYFx+YAPaNxjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201109151910.17018.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 15. September 2011, 19:03:11 schrieb Sameer Nanda:
> The proposal is to enable wakeup by default on the intermediate bridge
> devices such as ehci-pci and ohci-hcd.  This allows wake from USB
> keyboard to work by default.  For non-keyboard devices, the user will
> still need to explicitly enable them as a wakesources so there is no
> change in the device wakeup policy from what is in place currently for
> those devices.

Have you tested what this means for power sessions on laptops?
Is power kept on under those conditions? How much testing has this
patch seen?

	Regards
		Oliver
-- 
- - - 
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg) 
Maxfeldstraße 5                         
90409 Nürnberg 
Germany 
- - - 
