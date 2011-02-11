Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070Ab1BKTlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 14:41:10 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35247 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758016Ab1BKTlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 14:41:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=lSs1KK3M9lA98FPnr+21mbhRhWxaepQqlii3sEfiIF9c4ib0HPoPAWA5dToNfNtX7g
         gxuJAuV4UJR7vHW4z5MQUodEbNJVvsLjayPDtlr+65nS8X/2d2HiQgzDKSe+nyDgtsBD
         rIg1rfTJca0afzMmRlGtxRQsM6cylvM2LhWwY=
MIME-Version: 1.0
In-Reply-To: <4D558EA7.2070707@redhat.com>
References: <20110122144513.GA2539@scooter>
	<20110122145222.GB2539@scooter>
	<20110122151124.GC29985@carfax.org.uk>
	<20110122155612.GA3664@scooter>
	<20110123181827.GF29985@carfax.org.uk>
	<4D3CA568.7050506@libero.it>
	<20110124130104.GA7354@scooter>
	<4D3E160F.4050006@csamuel.org>
	<20110210122927.GB20488@foxbat.suse.cz>
	<20110211130412.GA2591@scooter>
	<4D55870C.8020805@redhat.com>
	<AANLkTi=Arg-09F0DXsWNhsYgyPar=rKs7G_OQG2uMm4f@mail.gmail.com>
	<4D558EA7.2070707@redhat.com>
Date: Fri, 11 Feb 2011 20:41:05 +0100
Message-ID: <AANLkTi=AnavGD9s7sQdNGcgjKNUdiEhFZyLsyc0ROpL7@mail.gmail.com>
Subject: Re: LOOP_GET_STATUS(64) truncates pathnames to 64 chars (was Re: Bug
 in mkfs.btrfs?!)
From: Felix Blanke <felixblanke@gmail.com>
To: Milan Broz <mbroz@redhat.com>
Cc: Chris Samuel <chris@csamuel.org>, kreijack@inwind.it,
        linux-btrfs@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Hugo Mills <hugo-lkml@carfax.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah, for me its loop-aes.
Ah ok, didn't knew that it replaces that whole loop thing :)


Felix

On Feb 11, 2011 8:32 PM, "Milan Broz" <mbroz@redhat.com> wrote:
> On 02/11/2011 08:23 PM, Felix Blanke wrote:
>> What do you mean with "configured"?
>>
>> I'm using loop devices with loop aes, and I've looked into /sys for a device which is actually in use.
>
> Ehm. It is really Loop-AES?
>
> Then ask author to backport it there, Loop-AES is not mainline code.
> He usually replaces the whole upstream loop implementation with old patched version.
>
> Milan
