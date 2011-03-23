Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524Ab1CWLJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 07:09:43 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:46373 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326Ab1CWLJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 07:09:42 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D89D541.8060303@cam.ac.uk>
Date: Wed, 23 Mar 2011 11:10:57 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: "Cai, Cliff" <Cliff.Cai@analog.com>
CC: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Drivers <Drivers@analog.com>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        Cliff Cai <cliff@analog.com>
Subject: Re: [PATCH RESEND v2]IIO driver for Analog Devices Digital Output
 Gyroscope ADXRS450
References: <1300526846-27183-1-git-send-email-cliff.cai@analog.com> <4D878D8B.6070902@cam.ac.uk> <DB904C5425BA6F4E8424B3B51A1414D167E0335EA6@NWD2CMBX1.ad.analog.com>
In-Reply-To: <DB904C5425BA6F4E8424B3B51A1414D167E0335EA6@NWD2CMBX1.ad.analog.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...
>>> +}
>>> +
>> I note there are two versions of this chip (from datasheet).
>> We should probably support changing this axis according to
>> which one we have.  Z is out of chip plane. The other two are
>> arbitrary if we only have 1 axis on the chip.
> 
> Currently,I don't know the way to tell what kind package the device has.
> So,just keep the Z-axis one.
> 
Fine.  Only way I can think of doing it would be to use an id_table
and rely on the board file being correct.  I guess this is a feature
someone can add when they want it!

As an aside: It is really helpful if you crop the text when responding
to a particular point in an email - keeps a particular branch of a thread
focussed and easy to follow.

Jonathan
...
