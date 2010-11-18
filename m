Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737Ab0KRR2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 12:28:18 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60999 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab0KRR2R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 12:28:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=tEw+4BH/9vMnYgNiWcJPWRUVL8FsBbznHeHc5wqkOcBqpEPcYAswpJIbRt9jGYrfxU
         hQJB7D6q4d77ANLes+KA9O/7EyEBppaRZxPBtfGOm2wieP6A2zHOBtYaiXEKA++3Ufhd
         oSHxK5UnMA9tCnL4N8YGIA/HGUm3QBfO86M+s=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [Regression] [2.6.37-rc2] WARNING: at drivers/pci/pci-sysfs.c:758 pci_mmap_resource+0x133/0x190()
Date: Thu, 18 Nov 2010 18:28:11 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.4.5; i686; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, martin.wilck@ts.fujitsu.com
References: <201011172153.11313.maciej.rutecki@gmail.com> <20101117130018.432b0ec8@jbarnes-desktop>
In-Reply-To: <20101117130018.432b0ec8@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201011181828.11943.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On środa, 17 listopada 2010 o 22:00:18 Jesse Barnes wrote:
> On Wed, 17 Nov 2010 21:53:10 +0100
> 
> Maciej Rutecki <maciej.rutecki@gmail.com> wrote:
> > Last known good: 2.6.37-rc1
> > Bad kernel: 2.6.37-rc2
> > Hardware: VirtualBox
> 
> Should be fixed in master now, please re-test.

Yes, update to latest kernel tree, and kernel works OK.

Thanks
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
