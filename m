Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab0I0Lmr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 07:42:47 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64808 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab0I0Lmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 07:42:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=WLWL0dSlqbiFY+6OtOOLx9fG7aJwzkMsZYmxJ3hSTHl6Fi2kQiTImgwMma8sPAhLeg
         vzw+ef1dwjfEK5frx/u4KPsbVKUMu3JNlvaAgfJYMN29pxqnUXrbh4dQ+X1D+qOOiEDP
         /j+PDQmRyzMYH/XnUXfH/mVbMGv6n/9+PTWRo=
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Subject: Re: Interrupt latency on some 945GM platforms
Date: Mon, 27 Sep 2010 14:41:17 +0300
User-Agent: KMail/1.13.5 (Linux/2.6.35-gentoo-r8-anarsoul; KDE/4.5.1; i686; ; )
Cc: Stefan Biereigel <security@biereigel-wb.de>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Sitsofe Wheeler <sitsofe@yahoo.com>,
        Venkatesh Pallipadi <venki@google.com>,
        intel-gfx@lists.freedesktop.org, Len Brown <lenb@kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
References: <201009132336.17310.anarsoul@gmail.com> <4C9F262F.7030709@biereigel-wb.de> <AANLkTinZ-A-D=yEsN00dGB=fpTgV72BgrEra9UpkmVHX@mail.gmail.com>
In-Reply-To: <AANLkTinZ-A-D=yEsN00dGB=fpTgV72BgrEra9UpkmVHX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Message-Id: <201009271441.17703.anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 of September 2010 03:46:23 Shaohua Li wrote:

> does disable msi help with 'pci=nomsi'?

Doesn't help on my system :(
