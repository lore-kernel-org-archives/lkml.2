Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab0DSTms (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 15:42:48 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:54644 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab0DSTmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 15:42:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sp4d5gYI3crWLmijsFQ8eUu1liMeQ5UiInub6b2onEkoQqM/a5d2MAI5mGStY4RGHS
         lASDm3FsMw8qS8kYqVZle91fESCxytBZbqGvxaE+XO3K3Su/zG6Y4/MYBsWiAQE0gUGP
         s+Kp9bCMoKOmhE9cs6Tp6jmJOHIoPefvFUeQU=
Subject: Re: [regression, bisected] Xonar DX invalid PCI I/O range since 
 977d17bb174
From: Peter Henriksson <peter.henriksson@gmail.com>
To: Yinghai <yinghai.lu@oracle.com>
Cc: Clemens Ladisch <clemens@ladisch.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4BCCA5FD.6060002@oracle.com>
References: <4BCBFE89.9070401@ladisch.de>
	 <o2gf046f1351004190044h6c3f6536ga916d2fa047f3fe7@mail.gmail.com>
	 <4BCC0F10.3070208@ladisch.de>
	 <l2sf046f1351004190142ocb2e5f1fyc0e892489caa76a3@mail.gmail.com>
	 <4BCCA5FD.6060002@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 21:42:41 +0200
Message-ID: <1271706161.2505.6.camel@darwin.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.0.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-19 at 11:50 -0700, Yinghai wrote:
> please try:
> 
> [PATCH] pci: disable pci trying to reallocate pci bridge by default.
> 
> it broken Linus's Nouveau
> 

Not sure why but I had to use some spit and glue to get it to apply.
Other than that, works for me, thanks.

Cheers,
Peter

