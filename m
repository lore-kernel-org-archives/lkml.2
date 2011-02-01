Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab1BAPfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 10:35:45 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:54777 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab1BAPfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 10:35:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Ohad Ben-Cohen" <ohad@wizery.com>
Subject: Re: [PATCH v4 1/4] drivers: hwspinlock: add framework
Date: Tue, 1 Feb 2011 16:34:54 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Greg KH <greg@kroah.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>, Suman Anna <s-anna@ti.com>,
        Kevin Hilman <khilman@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Hari Kanigeri <hari.kanigeri@gmail.com>,
        Simon Que <simonque@gmail.com>
References: <1296470024-26854-1-git-send-email-ohad@wizery.com> <1296470024-26854-2-git-send-email-ohad@wizery.com>
In-Reply-To: <1296470024-26854-2-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201102011634.54762.arnd@arndb.de>
X-Provags-ID: V02:K0:m7TnJPRdPhCb8nmWTlLvw094RVQ6NLUkLvGuTpVkTwP
 6+aU5SC22VklnDyEX+59wULM3I5lr1TnpmOBMdkJ15wvm7Q5Yv
 pvj7V7DWuy4P3E1C8pPlHq1fLlVsy+KhwkqbrVrRxphgWDUd9n
 UTw9Al57tLKyohL3zEXkba4tb2G0Dyj6AhDvuFAgr+m1EBuhqu
 lehgCCmVCOQ0nHekdIF7Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 January 2011, Ohad Ben-Cohen wrote:
> Add a platform-independent hwspinlock framework.
> 
> Hardware spinlock devices are needed, e.g., in order to access data
> that is shared between remote processors, that otherwise have no
> alternative mechanism to accomplish synchronization and mutual exclusion
> operations.
> 
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> Cc: Hari Kanigeri <h-kanigeri2@ti.com>
> Cc: Benoit Cousson <b-cousson@ti.com>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Paul Walmsley <paul@pwsan.com>
> Acked-by: Tony Lindgren <tony@atomide.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
