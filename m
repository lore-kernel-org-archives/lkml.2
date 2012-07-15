Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601Ab2GOTw0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 15:52:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52005 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab2GOTwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 15:52:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Devendra Naga <develkernel412222@gmail.com>
Subject: Re: [PATCH] powerpc/BSR: cleanup the error path of bsr_init
Date: Sun, 15 Jul 2012 19:52:17 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
References: <1342358522-10956-1-git-send-email-develkernel412222@gmail.com>
In-Reply-To: <1342358522-10956-1-git-send-email-develkernel412222@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207151952.17634.arnd@arndb.de>
X-Provags-ID: V02:K0:Dj1afW40ZOsEw5GEX+a4LnA2dyqQI45rxygGp2u22D5
 B7VghctOXZERzfwz87Qf2VzZ9SdJS17M9nSRbrCHhxZ/31jnyq
 rNYMidQ3arCMXmsKvdDlFQAow7aCk+fdwFv82wxAcL+gCWthc6
 bIe+v3lJLyaBL3HyaUIScFymx6hSCjxuW91Woec5rH/rilGqxa
 KMsy1RVu0a2mpZRPYNCtXGirZRRYYMhugs9mB+Xj04sE9eVJyf
 nLA4XoNChogDSl2wg9szLsedOqPH2Z4aSKYvQhyfln+UDc6OLq
 AdgJ8Buk1xuY5LqaReNXnZ2gA0cSsfh2IVvMKrIKpbp6CaXLnJ
 ZJD1yu7GvEhbqHfr+iNk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 July 2012, Devendra Naga wrote:
> class_create if succeeded returns a pointer to the struct class,
> and if it fails, it returns a value enclosed by the pointer, which
> can be read by using PTR_ERR.
> 
> Handle the error and return it.
> 
> result is for error checking of the alloc_chrdev_region, instead
> ret can be used, and also if the alloc_chrdev_region fail,
> we are still returning -ENODEV, use ret and the error path will
> take care of returning of the ret.
> 
> Signed-off-by: Devendra Naga <develkernel412222@gmail.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
