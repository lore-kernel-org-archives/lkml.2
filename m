Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751237Ab1ENEOq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 00:14:46 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45395 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab1ENEOp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 00:14:45 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1105120940490.28229@xanadu.home>
References: <BANLkTi=yCmxgv1fQKRJSZK3FkkRwjS2r=Q@mail.gmail.com>
 <20110511211438.GM5315@n2100.arm.linux.org.uk> <alpine.LFD.2.00.1105120940490.28229@xanadu.home>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 14 May 2011 06:14:24 +0200
X-Google-Sender-Auth: _wYJ2Pzy8Yv4nIkiHd-es7YY8ck
Message-ID: <BANLkTi=V337ojovBwiTA9Lnt0OMj0SGTRQ@mail.gmail.com>
Subject: Re: [PATCH v6 0/5] Basic ARM devicetree support
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 9:47 AM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> On Wed, 11 May 2011, Russell King - ARM Linux wrote:
>
>> On Wed, May 11, 2011 at 10:44:49PM +0200, Grant Likely wrote:
>> > Right now it merges cleanly with linux-next and the resulting tree
>> > builds and boots at least on qemu.  Unless you really object, I'm
>> > going to ask Stephen to add the following branch to the /end/ of the
>> > list of trees for linux-next so it can easily be dropped it if it
>> > causes any problems.
>>
>> As far as the set of five patches looks fine to me, I don't have any
>> objections against them.  So I think we can merge them for .40.

Yay!  Thanks Russell!

>> What I've always worried about is the platform stuff, and that's
>> something I'm going to continue worrying about because I don't think
>> we have sufficient review capacity to ensure that we don't end up
>> with lots of stupidities.

Understood, and I agree to a point, but I'm cautiously optimistic that
the review process we talked about heavily this week will be able to
push back on bad bindings to prevent a lot of these problems.  It also
helps that we we can cut over to device tree in board ports in stages
without needing a change-everything-flag-day.  Devices can be
converted one by one, which will limit the volume of stuff that needs
to be reviewed at one time.

> DT is certainly not a silver bullet.  Good judgement will be needed as
> to what is put in DT and how it is represented.  I don't think that it
> would make things worse than they are now though.

+1

> I also do have some concerns about some aspects of DT which I've
> expressed several times in the past.  However I don't think holding back
> those patches any longer is a solution though.
>
> So consider this as a ACK from my part to merge those patches now.  This
> will get the ball rolling.

Thanks Nicolas.

g.
