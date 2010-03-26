Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab0CZW1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 18:27:53 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:51052 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648Ab0CZW1v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 18:27:51 -0400
MIME-Version: 1.0
In-Reply-To: <1269642001.3001.325.camel@iscandar.digidescorp.com>
References: <1268843188-15292-1-git-send-email-steve@digidescorp.com> 
	<fa686aa41003261433x312453dfgca325cae3bbaf91@mail.gmail.com> 
	<1269642001.3001.325.camel@iscandar.digidescorp.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 26 Mar 2010 16:27:29 -0600
X-Google-Sender-Auth: d148c8b88ecfc880
Message-ID: <fa686aa41003261527g434b1971k35422f91479d2e11@mail.gmail.com>
Subject: Re: [microblaze-uclinux] Re: [PATCH 3/4] dmaengine: xlldma platform 
	bus driver
To: steve@digidescorp.com
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       monstr@monstr.eu, microblaze-uclinux@itee.uq.edu.au
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 4:20 PM, Steven J. Magnani
<steve@digidescorp.com> wrote:
> On Fri, 2010-03-26 at 15:33 -0600, Grant Likely wrote:
>> On Wed, Mar 17, 2010 at 10:26 AM, Steven J. Magnani
>> <steve@digidescorp.com> wrote:
>> > Platform bus attachment for the Xilinx MPMC Soft Direct Memory
>> > Access Controller DMA engine.
>> >
>> > Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
>> > ---
>> > diff -uprN a/drivers/dma/xlldma_plat.c b/drivers/dma/xlldma_plat.c
>> > --- a/drivers/dma/xlldma_plat.c 1969-12-31 18:00:00.000000000 -0600
>> > +++ b/drivers/dma/xlldma_plat.c 2010-03-17 11:11:16.000000000 -0500
>>
>> Not really worth putting into a separate file.  Just put this hunk in
>> the xlldma.c file to keep a few more symbols out of the global
>> namespace.
>
> I can certainly do that, but as someone who's had to add platform bus
> attachments to drivers that only have OF attachments, I can say from
> experience that the result ends up being rather messy. I thought
> (explicitly) decoupling the bus logic from the driver might be an
> improvement. Maybe it's not enough of a benefit.

of_platform is geting merged with platform bus so this issue is going
away.  Just put it all in one file.

g.
