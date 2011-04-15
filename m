Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556Ab1DOPq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 11:46:57 -0400
Received: from imr4.ericy.com ([198.24.6.8]:33123 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab1DOPq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 11:46:56 -0400
Date: Fri, 15 Apr 2011 08:46:08 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: "wni@nvidia.com" <wni@nvidia.com>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "olofj@chromium.org" <olofj@chromium.org>,
        "achew@nvidia.com" <achew@nvidia.com>
Subject: Re: [PATCH 2/3] hwmon (lm90) Support to configure nct1008 from
 platform data
Message-ID: <20110415154608.GA24844@ericsson.com>
References: <1302865228-7185-1-git-send-email-wni@nvidia.com>
 <1302865228-7185-3-git-send-email-wni@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1302865228-7185-3-git-send-email-wni@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 07:00:27AM -0400, wni@nvidia.com wrote:
> From: Wei Ni <wni@nvidia.com>
> 
> This patch add support to configure nct1008 from platform data.
> 

In my opinion those enhancments should not only be for nct1008 but
apply to all chips, ie be made generic. Not even supporting the functionally
identical chips does not make sense to me at all.

Guenter

