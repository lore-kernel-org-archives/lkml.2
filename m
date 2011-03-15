Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967Ab1COOfD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 10:35:03 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:59020 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757874Ab1COOfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 10:35:00 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D7F794F.4050800@cam.ac.uk>
Date: Tue, 15 Mar 2011 14:35:59 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jean Delvare <khali@linux-fr.org>,
        mems applications <mems.applications@st.com>, rdunlap@xenotime.net,
        carmine.iascone@st.com, matteo.dameno@st.com, rubini@cvml.unipv.it,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <guenter.roeck@ericsson.com>, Greg KH <greg@kroah.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH] Add STMicroelectronics LPS001WP pressure sensor device
 driver into misc
References: <1300128906-1066-1-git-send-email-matteo.dameno@st.com> <4D7F4944.4070507@cam.ac.uk> <20110315125149.GC17277@sirena.org.uk> <201103151431.22052.arnd@arndb.de>
In-Reply-To: <201103151431.22052.arnd@arndb.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/11 13:31, Arnd Bergmann wrote:
> On Tuesday 15 March 2011, Mark Brown wrote:
>>> 2) Basically make a copy.  This would look like the original patch set did when we went
>>
>> A third option is just to lift everything out of staging roughly as it
>> is now with anything that definitely needs redoing dropped, addressing
>> any review comments for mainline but not doing much else, and then
>> resume working on adding additional stuff.  It sounds like the userspace
>> interfaces that are there at present are mostly OK and most of the
>> issues are in-kernel?
>>
>> You could perhaps have a Kconfig control for disabling any experimental
>> features in the API if you want to give people hints about areas that
>> are likely to churn.
> 
> I agree, that sounds like a good idea for preparing the code before a split.
Indeed a good idea.  I'll add one of those.
> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

