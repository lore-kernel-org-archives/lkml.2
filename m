Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933704Ab1JEIo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 04:44:29 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:48182 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab1JEIo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 04:44:28 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E8C1AE6.5000701@cam.ac.uk>
Date: Wed, 05 Oct 2011 09:52:54 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110930 Thunderbird/6.0.2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: IIO (+ more general?) Error condition handling (e.g. wire fell
 out errors)
References: <4E858F5A.5000901@cam.ac.uk> <20110930104707.0645afda@lxorguk.ukuu.org.uk>
In-Reply-To: <20110930104707.0645afda@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the slow reply!
>> 3) Consider these out of band (from the out of band event data)
>> and look at other options for reporting them.
> 
> Treat it like a socket/pipe perhaps - if it "goes down" then report it as
> having hung up and deliver a SIGPIPE or similar and with an appropriate
> error code for those catching it (-EIO ?)
I guess that will work.  Feels a little clunky, but such is life.
> 
> That generally gets noticed.
> 
>> Is there anything general out there for reporting hardware failures
>> that would be appropriate?  Sometime these conditions are the sort
>> of thing that should cause a siren to go off.
>> They might be sensor failure
> 
> There are two things here - one is making sure the app notices (where we
> have equivalent handling in other interfaces) the other is what to do
> about it. We don't have a general framework for reporting system
> component failure. That's something that ought to get fixed generally to
> report everything from "that new nasty smell was formerly your hard disk"
> to a sensor fail.
It does seem like that would be useful. 
> 
>> (p.s. I hope no one is using the current driver for trains, though
>> that might explain British trains...)
> 
> Tssh... there is Linux on UK trains, but it's usually driving annoying
> announcement/video systems.
:) Good thing their are no 'this runs Linux' badges on the speakers.
I've nothing against them using Linux, just the driver in question which
is currently 'interesting'.

Thanks,

Jonathan

