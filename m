Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718Ab1BRAyi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 19:54:38 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:45627 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751554Ab1BRAyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 19:54:31 -0500
Message-ID: <4D5DC368.2080003@bluewatersys.com>
Date: Fri, 18 Feb 2011 13:55:04 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Greg KH <greg@kroah.com>, Charles Manning <manningc2@actrix.gen.nz>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/10] Add yaffs2 file system:  Fifth patchset
References: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com> <201102171531.03924.manningc2@actrix.gen.nz> <4D5C8D62.4060809@bluewatersys.com> <201102171649.57457.manningc2@actrix.gen.nz> <20110217234154.GA1474@kroah.com> <20110218000150.GA27668@opensource.wolfsonmicro.com> <20110218003353.GA25386@kroah.com> <20110218004354.GB27668@opensource.wolfsonmicro.com>
In-Reply-To: <20110218004354.GB27668@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2011 01:43 PM, Mark Brown wrote:
> On Thu, Feb 17, 2011 at 04:33:53PM -0800, Greg KH wrote:
>> On Fri, Feb 18, 2011 at 12:01:50AM +0000, Mark Brown wrote:
> 
>>> For the proc stuff - for tracing stuff then tracepoints are likely to be
>>> a good option if it's useful to people.
> 
>> Then use the in-kernel tracing functionality, don't roll your own.  And
>> that is not in /proc, so it should be there for this filesystem either.
> 
> That'd be the tracepoints I was mentioning, then...

Are you suggesting that the yaffs_trace function should be replaced with
tracepoints?

yaffs_trace is basically just a wrapper around printk, which I suggested
should be replaced with pr_debug so that it can be compiled out
completely. Other drivers and filesystems have similar custom debugging
functions.

I haven't used tracepoints, but it seems like they are better suited to
tracing specific events than as a general printk style debugging
replacement?

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
