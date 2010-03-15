Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830Ab0COWcL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 18:32:11 -0400
Received: from elettra.colt-to.towertech.it ([213.215.222.70]:47910 "EHLO
	elettra.colt-to.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756467Ab0COWcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 18:32:08 -0400
Date: Mon, 15 Mar 2010 23:32:03 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kevin Hilman <khilman@deeprootsystems.com>, rtc-linux@googlegroups.com,
       Miguel Aguilar <miguel.aguilar@ridgerun.com>,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Samuel Ortiz <sameo@linux.intel.com>, Kyle McMartin <kyle@mcmartin.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RTC: DaVinci RTC driver
Message-ID: <20100315233203.00627c75@linux.lan.towertech.it>
In-Reply-To: <20100315142024.afa998d9.akpm@linux-foundation.org>
References: <1268420914-6731-1-git-send-email-khilman@deeprootsystems.com>
	<20100315142024.afa998d9.akpm@linux-foundation.org>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Mar 2010 14:20:24 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> I'm looking suspiciously at these (slow-looking) functions.  Are they
> really specific to this device, or could we be making better use of
> library code, or adding functionality to library code?

 I truly hope no other driver with similar needs ;)

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

