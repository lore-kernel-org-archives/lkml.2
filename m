Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab0FWHns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 03:43:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33102 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808Ab0FWHnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 03:43:47 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Alexander Samad <alex@samad.com.au>
Subject: Re: help identify wwan card
Date: Wed, 23 Jun 2010 08:52:36 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-9-desktop; KDE/4.4.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <AANLkTilzxC6OdOCGiVfa6a7FMZXWRLNnPZ5lhTNnWCV4@mail.gmail.com>
In-Reply-To: <AANLkTilzxC6OdOCGiVfa6a7FMZXWRLNnPZ5lhTNnWCV4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006230852.36290.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 23. Juni 2010, 04:53:49 schrieb Alexander Samad:
> Hi
> 
> I have got a new laptop HP 2540p, it has a qualcom 3g card, I had one
> in my hp mini and was able to get it to work with the qcserial module.
> 
> now I can't find it on my new laptop.

qcserial is a USB driver. You certainly won't find a USB device with lspci.
You need lsusb.

	Oliver

