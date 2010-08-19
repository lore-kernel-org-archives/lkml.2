Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751097Ab0HSUTA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 16:19:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55470 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745Ab0HSUS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 16:18:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: [Regression, 2.6.36-rc1] ath9k resume problem on Acer Ferrari One
Date: Thu, 19 Aug 2010 22:17:14 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc1-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Luis Rodriguez <lrodriguez@atheros.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        Maciej Rutecki <maciej.rutecki@gmail.com>
References: <201008190001.11342.rjw@sisk.pl> <4C6D3D5C.7010504@kernel.org> <4C6D3E49.7080601@gmail.com>
In-Reply-To: <4C6D3E49.7080601@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008192217.14774.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 19, 2010, Tejun Heo wrote:
> Oh, can you also please attach log of the BUG()?

That's difficult, because I have no way to collect it after it's happened.

I can try to convert it to WARN_ON or rewrite the call trace by hand.

Or I may try to make a photo. :-)

Thanks,
Rafael
