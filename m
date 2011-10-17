Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab1JQJoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 05:44:55 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:39252 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab1JQJox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 05:44:53 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E9BF91A.9090107@cam.ac.uk>
Date: Mon, 17 Oct 2011 10:44:58 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111003 Thunderbird/7.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Linus Walleij <linus.ml.walleij@gmail.com>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, zdevai@gmail.com
Subject: Re: [PATCH] staging:iio:proof of concept in kernel interface.
References: <1318333383-17663-1-git-send-email-jic23@cam.ac.uk> <1318333383-17663-2-git-send-email-jic23@cam.ac.uk> <20111013143224.GO1098@sirena.org.uk> <4E96F9AC.9000001@cam.ac.uk> <20111013204410.GA17160@sirena.org.uk> <4E985C60.9020308@cam.ac.uk> <CAKnu2MrUkY2upFh5d6GGTNUr-=r_JKcxh5OQNV63bdOCa4F+zg@mail.gmail.com> <20111017093913.GB3042@opensource.wolfsonmicro.com>
In-Reply-To: <20111017093913.GB3042@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/11 10:39, Mark Brown wrote:
> On Sun, Oct 16, 2011 at 08:45:06PM +0200, Linus Walleij wrote:
> 
>> Then this API feels comfortable:
> 
>> struct adc *adc_get(struct device *dev, const char *channel);
>> void adc_put(struct adc *adc);
>> int adc_read_raw(struct adc *adc, int *val);
> 
>> We can then add adc_read_voltage(), adc_read_temperature(), adc_read_foo() ...
> 
> That should work for pretty much all of the AUXADCs.
> 
Agreed with extra indirection for channel association as per my
other email.

