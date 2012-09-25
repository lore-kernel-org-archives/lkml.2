Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab2IYFV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 01:21:59 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:61588 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab2IYFV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 01:21:58 -0400
Message-ID: <50613F72.4000302@pobox.com>
Date: Tue, 25 Sep 2012 01:21:54 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [SCSI PATCH] sd: max-retries becomes configurable
References: <20120924210049.GA18527@havoc.gtf.org> <1348546019.2457.3.camel@dabdike>
In-Reply-To: <1348546019.2457.3.camel@dabdike>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2012 12:06 AM, James Bottomley wrote:
> On Mon, 2012-09-24 at 17:00 -0400, Jeff Garzik wrote:
>>
>>   drivers/scsi/sd.c |    4 ++++
>>   drivers/scsi/sd.h |    2 +-
>>   2 files changed, 5 insertions(+), 1 deletion(-)
>
> I'm not opposed in principle to doing this (except that it should be a
> sysfs parameter like all our other controls), but what's the reasoning
> behind needing it changed?

<vendor hat on>

Periodically turns up as a useful field sledgehammer for solving 
problems, until the real problem is found and fixed.  Got tired of a 
very similar patch manually bouncing around the "hey, pssst, this worked 
for me" backchannel IT network.

</red hat>

Can you be more specific about sysfs location?  A runtime-writable (via 
sysfs!) module parameter for a module-wide default seemed appropriate.

	Jeff



