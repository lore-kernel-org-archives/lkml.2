Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab1F0Nnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 09:43:40 -0400
Received: from imr4.ericy.com ([198.24.6.8]:51462 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab1F0Nnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 09:43:33 -0400
Date: Mon, 27 Jun 2011 06:42:39 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Alexander Stein <alexander.stein@systec-electronic.com>
CC: Fenghua Yu <fenghua.yu@intel.com>, Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: coretemp: Support for Intel Atom E6XX CPU (TunnelCreek)?
Message-ID: <20110627134239.GA10808@ericsson.com>
References: <201106271220.51953.alexander.stein@systec-electronic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201106271220.51953.alexander.stein@systec-electronic.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 06:20:51AM -0400, Alexander Stein wrote:
> Hello,
> 
> I have a patch (for v2.6.39) which adds support for Intel Atom E6XX 
> (TunnelCreek) to coretemp. It's merely only adding x86_model 0x26.
> But there are models (e.g. E660 and E660T) with different TjMax, namely 90 
> degrees C and 110 degrees C. But these different model can't be detected by 
> reading from hardware.
> IMO there should be some support to adjust the temperature from userspace. 
> Reading Documentation/hwmon/sysfs-interface only temp1_offset seems to be 
> useable. But I think it is somewhat misleading (especially on multicores), 
> because there must only be one offset.
> What do you think about this?
> 
You can adjust the reported temperature with an entry in sensors3.conf.

Guenter
