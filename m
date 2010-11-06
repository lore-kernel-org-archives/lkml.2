Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab0KFTke (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 15:40:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:54408 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210Ab0KFTkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 15:40:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,308,1286175600"; 
   d="scan'208";a="624186692"
Message-ID: <4CD5AF26.3010202@intel.com>
Date: Sat, 06 Nov 2010 12:40:22 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Tracey Dent <tdent48227@gmail.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "agust@denx.de" <agust@denx.de>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>
Subject: Re: [PATCH 1/2] Drivers: dma: Makefile: Cleaned up Makefile
References: <1289070217-2513-1-git-send-email-tdent48227@gmail.com>
In-Reply-To: <1289070217-2513-1-git-send-email-tdent48227@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2010 12:03 PM, Tracey Dent wrote:
> Use the ccflag-y instead of EXTRA_CFLAGS.

Thanks for the patch.

Please make the subject line: "drivers/dma/: Use the ccflag-y instead of 
EXTRA_CFLAGS", and the description say why it is preferable to use 
ccflag-y over EXTRA_CFLAGS.

That would make easy for me to judge why I should apply this.

Ditto for [PATCH 2/2]

--
Dan

