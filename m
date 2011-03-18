Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab1CRRuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 13:50:00 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:45554 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176Ab1CRRty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 13:49:54 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D839B84.1040201@cam.ac.uk>
Date: Fri, 18 Mar 2011 17:51:00 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Kay Sievers <kay.sievers@vrfy.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: Re: IIO comments
References: <201103152215.20059.arnd@arndb.de> <201103181718.08502.arnd@arndb.de> <4D83885C.3050402@cam.ac.uk> <201103181757.58218.arnd@arndb.de>
In-Reply-To: <201103181757.58218.arnd@arndb.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/11 16:57, Arnd Bergmann wrote:
> On Friday 18 March 2011, Jonathan Cameron wrote:
>>> I guess if it's always in${i}-in${i+1}, it's still not too hard.
>> I think they have been so far, but doubt this is universal.
>> How about having a diff type and just having a pair of indices in the
>> channel structure?  Actually may need a third for x^2+y^2+z^2 devices.
>> (iirc there are parts that do x^2+y^2 despite also having a z channel)
>> ...
> 
> If two identifiers are common, that would probably be fine.
> 
> If you have a x^2+y^2+z^2 device, it might be easier to call that
> a different type with a fixed name, as long as there is a small
> number of combinations.
True. A balance to be struck there as and when they occur.

Thanks,

Jonathan
