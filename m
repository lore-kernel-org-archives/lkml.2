Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364Ab1BXDdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 22:33:44 -0500
Received: from imr3.ericy.com ([198.24.6.13]:44670 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932305Ab1BXDdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 22:33:43 -0500
Date: Wed, 23 Feb 2011 19:32:51 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sean MacLennan <smaclennan@pikatech.com>,
        Frank Edelhaeuser <frank.edelhaeuser@spansion.com>,
        Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 1/2] hwmon: ad7414: add MODULE_DEVICE_TABLE
Message-ID: <20110224033251.GA4596@ericsson.com>
References: <1298514037.19027.3.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1298514037.19027.3.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 09:20:37PM -0500, Axel Lin wrote:
> The device table is required to load modules based on modaliases.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied.

Thanks,
Guenter
