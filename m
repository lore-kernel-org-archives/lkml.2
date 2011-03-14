Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab1CNUNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 16:13:23 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:53328 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211Ab1CNUNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 16:13:21 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D7E771B.1040804@cam.ac.uk>
Date: Mon, 14 Mar 2011 20:14:19 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: mems applications <mems.applications@st.com>, rdunlap@xenotime.net,
        carmine.iascone@st.com, matteo.dameno@st.com, rubini@cvml.unipv.it,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] Add STMicroelectronics LPS001WP pressure sensor device
 driver into misc
References: <> <1300128906-1066-1-git-send-email-matteo.dameno@st.com> <4D7E6A38.7010801@cam.ac.uk> <201103142046.25393.arnd@arndb.de>
In-Reply-To: <201103142046.25393.arnd@arndb.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/11 19:46, Arnd Bergmann wrote:
> On Monday 14 March 2011 20:19:20 Jonathan Cameron wrote:
>> The big issue raised last time around is that this is not a conventional human
>> input device.  Hence Dmitry isn't going to take it into input.  That doesn't
>> just mean that you have to move it's physical location; it also means you have
>> to not use the input interfaces at all.
> 
> How about making this a hwmon driver instead?
> There are already a number of temperature sensor drivers in
> driver/hwmon/, I think it would fit in well there.
hwmon are fairly forceful about not taking things that aren't for monitoring
hardware.  Even the humidity sensors in there are still controversial.
As it has been suggested I've cc'd Guenter and Jean just in case I'm wrong on
this.
> 
> This would mean moving it to the other directory,
> registering it to the common hwmon api (hwmon_device_register)
> and rewriting the user API to blend in with the other
> hwmon drivers.
> 
> 	Arnd
> 

