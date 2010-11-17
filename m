Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935009Ab0KQREI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 12:04:08 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63162 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934933Ab0KQREH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 12:04:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vFRTeiKbBW4LCdYBdnQOIi+wJowwNdd6hJ+deSXvLzOOxYCvsBECVd3q8ZEJit3H9H
         axLCZPcBb9CyRtI/EC/BJpbOuj84dk6prK9OmQAl6xHyzou5KudaqLZ/1jOVWmujESsZ
         nwtZhN6rop2cNkYUJHIfrPgwDG9KHvv50ZVds=
MIME-Version: 1.0
In-Reply-To: <4CE3F773.2010303@kernel.org>
References: <AANLkTinOg6n3ZA+0gHzw9LouRuUmJ7DJwHtABRy5c=gM@mail.gmail.com>
	<4CD26948.7050009@kernel.org>
	<20101104164401.GC10656@sundance.ccs.neu.edu>
	<4CD3CE29.2010105@kernel.org>
	<AANLkTimDXKsBCxbsEOfgkYV2R8FK=bhFdmx9UQow5hqp@mail.gmail.com>
	<4CD5DCE3.3000109@cs.columbia.edu>
	<20101107194222.GG31077@sundance.ccs.neu.edu>
	<4CD71A6B.3020905@cs.columbia.edu>
	<20101107230516.GJ31077@sundance.ccs.neu.edu>
	<4CD774CA.8030004@cs.columbia.edu>
	<20101108162630.GN31077@sundance.ccs.neu.edu>
	<8739rbpreb.fsf@localhost6.localdomain6>
	<4CE3B927.1020401@kernel.org>
	<8762vwvubr.fsf@localhost6.localdomain6>
	<4CE3F773.2010303@kernel.org>
Date: Wed, 17 Nov 2010 19:04:04 +0200
Message-ID: <AANLkTikox4HcXzekv7nBOBRhCsyuz4aZ6rKqyrHFrVA-@mail.gmail.com>
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Dan Smith <danms@us.ibm.com>, Gene Cooperman <gene@ccs.neu.edu>,
        Oren Laadan <orenl@cs.columbia.edu>, Kapil Arya <kapil@ccs.neu.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, hch@lst.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 5:40 PM, Tejun Heo <tj@kernel.org> wrote:
> The horror show part is dumping internal data structure without due
> scrutinization in a way which can only ever be useful for CR when most
> of the same states are already exported via ABI defined ways.

That's what review process is for, isn't it?

Please, look at what is being dumped and what isn't.
