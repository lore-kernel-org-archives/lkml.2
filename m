Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab0HDSqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 14:46:53 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41924 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab0HDSqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 14:46:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JsJD9MOMHo1Yi0ff1Qb2zNlpQPEENQp7dLz1W+F2aFRrQc5bE3BV3lw8DYg7LfT/aS
         Ebe8XLisqY+i1M8m5rGwjZzYKD0+Dt8LnR9e7v1zUR9cID9enTHAj47zyyM6OGttJnTZ
         7jgRZ14kbTziO9cwhy6ceff9R5s9GnhJ1Ndg8=
Message-ID: <4C59B576.4090807@garzik.org>
Date: Wed, 04 Aug 2010 14:46:14 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates
References: <20100804015530.GA8136@havoc.gtf.org> <AANLkTik-68XiTq3VC6ta3-YVL8r=FpwFErAx8nVV4CJ4@mail.gmail.com>
In-Reply-To: <AANLkTik-68XiTq3VC6ta3-YVL8r=FpwFErAx8nVV4CJ4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2010 02:32 PM, Linus Torvalds wrote:
> On Tue, Aug 3, 2010 at 6:55 PM, Jeff Garzik<jeff@garzik.org>  wrote:
>>
>> Tejun Heo (4):
>>       ata_generic: drop hard coded DMA force logic for CENATEK
>>       ata_piix: fix locking around SIDPR access
>>       libata: more PCI IDs for jmicron controllers
>>       sata_fsl,mv,nv: prepare for NCQ command completion update
>
> Hmm. Aren't these the ones that you said causes "sata_mv is behaving
> weirdly"? I think I'll wait for you to do another pull request when
> that is sorted out..

"prepare for..." is patch #1 of 2.  With #2, sata_mv starts behaving 
strangely.  #1 seems to be working here.

	Jeff


