Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab1EPXEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 19:04:25 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63338 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511Ab1EPXEY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 19:04:24 -0400
MIME-Version: 1.0
In-Reply-To: <20110516224353.GA19481@core.coreip.homeip.net>
References: <20110516214608.17011.3075.stgit@ponder> <20110516215110.GE16731@trinity.fluff.org>
 <20110516224353.GA19481@core.coreip.homeip.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 16 May 2011 17:04:04 -0600
X-Google-Sender-Auth: eTHz-kcBzdYt4fMCuEDEDAwKAj8
Message-ID: <BANLkTikfNZtP8DXH99RJE8H4pgZm4b9mjg@mail.gmail.com>
Subject: Re: [PATCH] input: Add Nintendo extension controller driver
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Ben Dooks <ben@trinity.fluff.org>, simon@mungewell.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        OliverNeukumoliver@neukum.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 4:43 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Mon, May 16, 2011 at 10:51:10PM +0100, Ben Dooks wrote:
>> On Mon, May 16, 2011 at 03:46:08PM -0600, Grant Likely wrote:
>> > +
>> > +   /*
>> > +    * DMA buffer, with padding to give it its own cache line so that
>> > +    * the DMA streaming works on non-coherent architectures.
>> > +    * Question: Is this the proper pattern, and is this really necessary?
>> > +    */
>> > +   uint8_t pad1[L1_CACHE_BYTES];
>> > +   uint8_t buf[6];
>> > +   uint8_t pad2[L1_CACHE_BYTES];
>> > +};
>>
>> I think there's an attribute to do this, starting with an __ defined
>> in the kernel.
>>
>
> Yes, it is called "____cacheline_aligned".

Fixed and tested, thanks.

g.
