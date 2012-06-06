Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab2FFHc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 03:32:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51904 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225Ab2FFHcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 03:32:19 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: stefani@seibold.net
Subject: Re: [PATCH] fix usb skeleton driver
Date: Wed, 6 Jun 2012 09:29:02 +0200
User-Agent: KMail/1.13.5 (Linux/3.3.0-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk
References: <1338966036-30443-1-git-send-email-stefani@seibold.net>
In-Reply-To: <1338966036-30443-1-git-send-email-stefani@seibold.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201206060929.02676.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 6. Juni 2012, 09:00:36 schrieb stefani@seibold.net:
> From: Stefani Seibold <stefani@seibold.net>
> 
> This is a fix for the USB skeleton driver to bring it in shape.
> 
> - The usb_device structure pointer will no longer stored 
> - Every access to the USB will be handled trought the usb_interface pointer
> - No longer assign a NULL to usb_interface pointer in the disconnect() handler

Why? What is gained?

	Regards
		Oliver
