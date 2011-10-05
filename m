Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934252Ab1JEJvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 05:51:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:25533 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933732Ab1JEJvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 05:51:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,490,1312182000"; 
   d="scan'208";a="74832393"
Date: Wed, 5 Oct 2011 12:51:14 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc: Fabio Estevam <festevam@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Chen <peter.chen@freescale.com>,
        Lin Tony-B19295 <B19295@freescale.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>
Subject: Re: [PATCHv5 14/19] arm: imx: Start using struct usb_otg
Message-ID: <20111005095114.GB7594@xps8300>
References: <1317036092-3000-1-git-send-email-heikki.krogerus@linux.intel.com>
 <20111003130409.GA2487@xps8300>
 <CAOMZO5DwDiBa_Ksow5bt02S_zMMEn4uB_hz-5KS+dyNiZA88sQ@mail.gmail.com>
 <201110041905.59247.philippe.retornaz@epfl.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201110041905.59247.philippe.retornaz@epfl.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 07:05:58PM +0200, Philippe Rétornaz wrote:
> Tested on mx31moboard-marxbot, works fine (ie, nothing changed).

Thanks Philippe. I assume we can add:

Tested-by: Philippe Rétornaz <philippe.retornaz@epfl.ch>

Sascha, I still would like you to test these, as you found the issues
in the v4.

Thanks,

-- 
heikki
