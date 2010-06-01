Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617Ab0FAAwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 20:52:54 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:35277 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab0FAAww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 20:52:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=bkQ0IFUoGh387dXBYejPxvlXBAsTXHZCNIFkVvb8bBFXtqRPmJWWba7Il+hnYzyIKo
         MtvLn13Qz69KKS1BZaWEl8gNr7tBHd+zvF8yPYKRt/PWIvdFS7BktWMlFlRsb1YnCUPp
         nMQ+oN0VJVAgsUZpcC1OpUYxSHCgDwAgMRXFU=
MIME-Version: 1.0
In-Reply-To: <1275353211.29006.9.camel@lithium.local.net>
References: <1275347969.29006.5.camel@lithium.local.net>
	<4C0448B5.7090904@gmail.com>
	<1275353211.29006.9.camel@lithium.local.net>
Date: Tue, 1 Jun 2010 10:52:50 +1000
Message-ID: <AANLkTinQkL41sFKM2ZuqH6GSAL5Vbc6iUEp8B5GsT06d@mail.gmail.com>
Subject: Re: Article in Phoronix about loss of performance in 2.6.35 release 
	candidates
From: Dave Airlie <airlied@gmail.com>
To: alex.buell@munted.org.uk
Cc: Mailing Lists - Kernel Developers <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 1, 2010 at 10:46 AM, Alex Buell <alex.buell@munted.org.uk> wrote:
> On Mon, 2010-05-31 at 17:39 -0600, Robert Hancock wrote:
>> On 05/31/2010 05:19 PM, Alex Buell wrote:
>> > http://www.phoronix.com/vr.php?view=14976
>> >
>> > Question: Why?
>>
>> Good question.. I guess it would too much to ask of them to try to
>> figure out what area the problem lies in (even to the point of figuring
>> out if it's a CPU or IO-bound problem), or try to bisect, or at least
>> report it to LKML before going to the trouble of creating 5 pages of
>> graphs.. Given the 20x slowdown in some of the benchmarks you'd think it
>> wouldn't be too hard to narrow down.
>
> What I really don't get is why they didn't talk to people on
> linux-kernel before posting those claims on phoronix. :S

Well thats kinda obvious, its "journalism" in the days of google
adwords. They make revenue by making people click on their website,
they don't make money being useful or interacting with others.
Phoronix in all the years I've been dealing with them as the only
place doing any reporting on graphics, have never once confirmed a
source, asked for information directly or anything you'd expect from
real journalists, again because that doesn't drive page hits, whereas
sensationalist useless headlines are the main point of the site.

Dave.
