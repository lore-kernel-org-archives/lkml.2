Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab0DZMGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 08:06:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41527 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093Ab0DZMGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 08:06:53 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Alessio Igor Bogani <abogani@texware.it>
Subject: Re: [PATCH] USB: sisusbvga: Remove the BKL from open
Date: Mon, 26 Apr 2010 14:06:50 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-0.1-default; KDE/4.3.5; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>,
       Thomas Winischhofer <thomas@winischhofer.net>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Pete Zaitcev <zaitcev@redhat.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1272191830-23675-1-git-send-email-abogani@texware.it>
In-Reply-To: <1272191830-23675-1-git-send-email-abogani@texware.it>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201004261406.50107.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 25. April 2010 12:37:10 schrieb Alessio Igor Bogani:
> BKL is not needed here because necessary locking is already provided
> by mutex sisusb->lock.

Have you checked the fb layer doesn't need it?

	Regards
		Oliver
