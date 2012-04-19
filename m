Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab2DSLLI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 07:11:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:39825 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011Ab2DSLLF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 07:11:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="90856143"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: Mika Westerberg <mika.westerberg@iki.fi>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: RE: [PATCH] smb347_charger: Cleanup power supply registration code
 in probe
Thread-Topic: [PATCH] smb347_charger: Cleanup power supply registration code
 in probe
Thread-Index: AQHNHfujIFWokHjRXkGOFoOupWQHLJah+sPQ
Date: Thu, 19 Apr 2012 11:10:58 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD10E4C0@BGSMSX102.gar.corp.intel.com>
References: <1334310292-22289-1-git-send-email-ramakrishna.pallala@intel.com>
 <20120419071104.GG18520@mwesterb-mobl.lan>
In-Reply-To: <20120419071104.GG18520@mwesterb-mobl.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sent: Thursday, April 19, 2012 12:41 PM
> To: Pallala, Ramakrishna
> Cc: linux-kernel@vger.kernel.org; Anton Vorontsov; Anton Vorontsov
> Subject: Re: [PATCH] smb347_charger: Cleanup power supply registration code in probe
> 
> On Fri, Apr 13, 2012 at 03:14:52PM +0530, Ramakrishna Pallala wrote:
> > This patch checks if the usb or mains charging is enabled by the
> > platform before registering with the power supply class.
> 
> Can you describe why this change is needed? The current code always registers all the
> power-supplies but if we haven't enabled for example USB charging, then the online
> property for USB ps is set to 0.

If we haven't enabled USB charging then why to waste kernel resources?
What we will gain by registering with power supply class if USB charging is not enabled?

Thanks,
Ram


