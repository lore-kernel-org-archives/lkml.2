Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483Ab0KLPwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 10:52:30 -0500
Received: from exprod5og111.obsmtp.com ([64.18.0.22]:60039 "EHLO
	exprod5og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab0KLPw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 10:52:29 -0500
Message-ID: <4CDD62B5.60500@ge.com>
Date: Fri, 12 Nov 2010 15:52:21 +0000
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/17] Series short description
References: <20101028175615.GA2367@kroah.com> <20101112111359.11631.84086.stgit@ES-BJ21R4J> <4CDD23A1.4000707@ge.com> <20101112151153.GU3891@flamenco.cs.columbia.edu>
In-Reply-To: <20101112151153.GU3891@flamenco.cs.columbia.edu>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Nov 2010 15:52:22.0761 (UTC) FILETIME=[984A9D90:01CB8281]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/10 15:11, Emilio G. Cota wrote:
> On Fri, Nov 12, 2010 at 11:23:13 +0000, Martyn Welch wrote:
>> Hi Greg,
>>
>> Here's the series of patches from Emilio I have been through and Acked.
>>
>> Sorry for not sending this sooner, bad health kept me from work. I have
>> promised to work through the remaining patches for Emilio, however the
>> absence from work and work commitments means this is going to take a
>> little longer than I had hoped (sorry Emilio). It is on my "todo" list.
> 
> Don't worry, as I said there's no rush in getting this merged (in
> production we're still using a fairly old kernel).
> 
> Hope you're well now.
> 

Getting there cheers, I'm off the hardcore pain-killers, not in
excruciating pain and fed up with day-time TV, so back at work ;)

>> I have applied minor edits to some of the patches to remove checkpatch
>> warnings, stacked git has the habit of correcting chunk offsets (which
>> may occur when re-ordering patches etc.), but I believe the others are
>> as sent by Emilio (with the addition of my ack).
> 
> Just FYI, if those checkpatch warnings were about lines exceeding 80
> characters, I consciously ignored them. After reading this[1] message I
> stopped trimming long lines, especially if they're just a few characters
> over the magic number.
> 

Yeah they were. I have a little python GUI I knocked up to help make
sure I send patch series correctly and don't have to keep working out
the options I need (long way from perfect yet), it refuses to allow me
to send if check patch doesn't pass and the few warnings were easier to
deal with than looking at improving the GUI!

Martyn

> Anyway this is just code formatting, either way is fine with me.
> 
> Thanks,
> 
> 		Emilio
> 
> [1] http://lkml.org/lkml/2009/12/17/229
> 


-- 
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square,
Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
