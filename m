Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938Ab2FFTCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 15:02:39 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:58931 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757364Ab2FFTCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 15:02:38 -0400
From: Oliver Neukum <oliver@neukum.org>
To: stefani@seibold.net
Subject: Re: [PATCH 04/11] remove usb_interface pointer
Date: Wed, 6 Jun 2012 20:59:25 +0200
User-Agent: KMail/1.13.5 (Linux/3.3.0-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk, linux-usb@vger.kernel.org
References: <1339000032-10313-1-git-send-email-stefani@seibold.net> <1339000032-10313-5-git-send-email-stefani@seibold.net>
In-Reply-To: <1339000032-10313-5-git-send-email-stefani@seibold.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201206062059.25125.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 6. Juni 2012, 18:27:05 schrieb stefani@seibold.net:
> 
> From: Stefani Seibold <stefani@seibold.net>
> 
> this saves a litte bit of memory space in the driver devices structure
> 

This really is the wrong way round.

	Regards
		Oliver

