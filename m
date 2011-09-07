Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab1IGTGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 15:06:25 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:53901 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab1IGTGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 15:06:24 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E67C29F.8060909@cam.ac.uk>
Date: Wed, 07 Sep 2011 20:14:39 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110901 Thunderbird/6.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org, Michael.Hennerich@analog.com,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH 2/6] regmap: Add a magic bus type to handle quirks of
 analog devices ADIS sensors.
References: <4E679770.4090008@cam.ac.uk> <1315412387-5765-3-git-send-email-jic23@cam.ac.uk> <20110907174713.GG2906@opensource.wolfsonmicro.com> <4E67B742.6030302@cam.ac.uk> <20110907183230.GA4423@opensource.wolfsonmicro.com> <4E67BCDF.3020108@cam.ac.uk> <20110907184457.GC4423@opensource.wolfsonmicro.com>
In-Reply-To: <20110907184457.GC4423@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/11 19:44, Mark Brown wrote:
> On Wed, Sep 07, 2011 at 07:50:07PM +0100, Jonathan Cameron wrote:
>> On 09/07/11 19:32, Mark Brown wrote:
> 
>>> Either.  Or either expose marshalling or add configuration for the
>>> marshalling depending on what's being done, I'm not convinced you need
>>> to be working at SPI level at all.
> 
>> I'm a little unclear what you mean by 'marshalling'.  Could you expand
>> on how that might work?
> 
> Marshalling is the process of formatting data for transmit and parsing
> it once it's been read in.
Ah, got you now.  Yes, something in there might work or as you say add some
hooks to do it outside.
