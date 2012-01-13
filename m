Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab2AMOFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 09:05:38 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52572 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758216Ab2AMOFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 09:05:34 -0500
Message-ID: <4F103A21.1050403@gmail.com>
Date: Fri, 13 Jan 2012 08:05:21 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Sascha Hauer <kernel@pengutronix.de>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [RFC v2 4/9] of: add clock providers
References: <1323727329-4989-1-git-send-email-grant.likely@secretlab.ca> <1323727329-4989-4-git-send-email-grant.likely@secretlab.ca> <20120113135036.GC17029@S2101-09.ap.freescale.net>
In-Reply-To: <20120113135036.GC17029@S2101-09.ap.freescale.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2012 07:50 AM, Shawn Guo wrote:
> On Mon, Dec 12, 2011 at 03:02:04PM -0700, Grant Likely wrote:
>> +==Clock providers==
>> +
>> +Required properties:
>> +#clock-cells:	   Number of cells in a clock specifier; typically will be
>> +		   set to 1
> 
> Shouldn't it be 0 typically, which means it represents only one clock
> in the node?
> 

We have no idea what will be typical. I would say: Typically 0 for nodes
with a single clock output and 1 for nodes with multiple clock outputs.

Rob
