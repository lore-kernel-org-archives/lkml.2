Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab0EFUuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 16:50:17 -0400
Received: from smtp-out.google.com ([216.239.44.51]:18093 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932610Ab0EFUuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 16:50:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=sender:date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:in-reply-to:
	x-operating-system:user-agent:x-system-of-record;
	b=BN4kNn5iGhPSTtpERjeWfx/GOkksPMqpPx0hxi10KxMSlnyWIXmrm31BXBtz7oREd
	zZzgcAuVuB4HKaX4ryZYA==
Date: Thu, 6 May 2010 13:49:52 -0700
From: Mandeep Singh Baines <msb@chromium.org>
To: Peter Feuerer <pfe@piie.net>
Cc: Rahul Chaturvedi <rkc@chromium.org>, linux-kernel@vger.kernel.org,
       msb@chromium.org
Subject: Re: [PATCH] CHROMIUM: acerhdf: fix bug when running on Qemu
Message-ID: <20100506204952.GA13101@google.com>
References: <1273122377-12137-1-git-send-email-rkc@chromium.org> <t2w1cd529021005052244sdefc0247n8d0b40a6612a3438@mail.gmail.com> <cone.1273176533.938023.17424.1000@deskpiie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cone.1273176533.938023.17424.1000@deskpiie>
X-Operating-System: Linux/2.6.24-gg804007-generic (x86_64)
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Feuerer (pfe@piie.net) wrote:
> Rahul Chaturvedi writes:
>
>> BTW, the CHROMIUM in the subject is just used for internal bookeeping
>> for patches not yet accepted upstream.
>
> What does it mean? Should I take care about getting it upstream?
>

You can drop it. We use it for internal bookkeeping in the chromium
git tree.

http://chromiumos-git/?p=kernel.git

Its useful to us when we rebase our kernel to a new 2.6.x.
We use it to record which tree the patch came from: did it come from
upstream, did we write, did we pull it from a maintainer tree.

> --peter;
