Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934108Ab0J1Scw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 14:32:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45663 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761273Ab0J1Scs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 14:32:48 -0400
Message-ID: <4CC9C171.80705@oracle.com>
Date: Thu, 28 Oct 2010 11:31:13 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Greg KH <greg@kroah.com>, Charles Manning <manningc2@actrix.gen.nz>,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: How do I add yaffs file system to mainline?
References: <201010290455.02390.manningc2@actrix.gen.nz>	 <20101028102641.d936aec8.randy.dunlap@oracle.com>	 <20101028174432.GA2001@kroah.com>	 <201010290655.39490.manningc2@actrix.gen.nz>	 <20101028180845.GA2573@kroah.com> <1288290559.1836.23.camel@Joe-Laptop>
In-Reply-To: <1288290559.1836.23.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/10 11:29, Joe Perches wrote:
> On Thu, 2010-10-28 at 11:08 -0700, Greg KH wrote:
>> On Fri, Oct 29, 2010 at 06:55:39AM +1300, Charles Manning wrote:
>>> I know there is a style guide etc, but when we're talking about processing 15k 
>>> loc then some of those rules might be slightly bendable.
>>
>> Not really.
>>
>> Have you run it through sparse and scripts/checkpatch.pl?  If not,
>> please do so and resolve all of the issues that they bring up.
> 
> I wouldn't do that.  Checkpatch is useful but frequently wrong.
> By all means do use checkpatch, but please use your own taste to
> determine what you think needs fixing.


Absolutely.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
