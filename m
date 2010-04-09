Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab0DIGJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 02:09:50 -0400
Received: from quoll.daa.com.au ([203.17.251.1]:51719 "EHLO quoll.daa.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756663Ab0DIGJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 02:09:39 -0400
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Apr 2010 02:09:39 EDT
Message-ID: <4BBEC35E.8060002@daa.com.au>
Date: Fri, 09 Apr 2010 14:04:14 +0800
From: James Andrewartha <jamesa@daa.com.au>
Organization: Data Analysis Australia
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
CC: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: 2.6.33: libata issues with VIA SATA/PATA controller
References: <201004090436.o394a0ao022460@turbo.physics.adelaide.edu.au>
In-Reply-To: <201004090436.o394a0ao022460@turbo.physics.adelaide.edu.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/04/2010 12:36 PM, Jonathan Woithe wrote:
> Hi Jeff
> 
>> A complete dmesg is definitely useful.
> 
> It's at the end of my previous post.
> 
>> Posting one from the failing kernel would be preferred, though.
> 
> Any ideas as to how I can capture it?  Since the SATA disc interfaces stop
> working long before they are mounted none of the early boot messages make it
> to disc.  All the interesting bits are therefore scrolled into the bit
> bucket.
> 
> A serial console might be doable (is there documentation about how to set
> one up?) but that would take some time to arrange - I'm only physically at
> the machine in question sporadically and I'd have to rustle up another PC
> ready for my next visit.  It could be done, but might take some time.

Netconsole is the easiest way to get dmesg when disks aren't working - see
Documentation/networking/netconsole.txt for details on how to set it up.

-- 
James Andrewartha
