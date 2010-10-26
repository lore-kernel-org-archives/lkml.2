Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab0JZBVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 21:21:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36538 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab0JZBVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 21:21:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sy3dW+NA/dHh4Y912cwAqwXKxvx1hnho1RW1nrBI6gFZuQVOwnLH6cF6+CSrAD4svG
         BP7YGQ4x0ylIwFB3fOd5HSoyJiFGiV/RMap0pLZi55C8ZQszwMaXV+Qdi0Ya2Pt6R1Rk
         H8jw9pZKibvVNLW3uoGHDM48ze0KjlDHMGqgQ=
Subject: Re: [PATCH 03/29] memstick: core: add new functions
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <117301.25688.qm@web37608.mail.mud.yahoo.com>
References: <117301.25688.qm@web37608.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 03:20:58 +0200
Message-ID: <1288056058.4024.39.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 07:56 -0700, Alex Dubov wrote:
> --- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Subject: [PATCH 03/29] memstick: core: add new functions
> > To: "Alex Dubov" <oakad@yahoo.com>
> > Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> > Received: Friday, 22 October, 2010, 4:53 PM
> > Add a lot of support code that will
> > be used later.
> > 
> 
> You're adding here a lot of temporarily dead code, which, while being
> useful, should be better added together with the actual driver
> functionality.
So what?
What is wrong with that?
Why should I mix things together?


> 
> Besides this, the patch has a lot of unneeded clean-ups which are better
> be set as a separate patch.
What cleanups?
So I added the memstick_power_off and make code use it
If you want even that as separate patch, ok.

And memstick_invalidate_reg_window in memstick_power_on?
Again at any rate it will be invalid there.
(Maybe I should have put that in memstick_power_off actually, will do)

If you want me to put these changes in separate patches, ok, I do it.


> 
> And it doesn't conform to the coding guideline either (4 byte indents,
> instead of tab
What?
I checked the patch with checkpatch.pl. It didn't complain.
I also use 8 byte tabs not 4.
Will look at that, thanks.

Best regards,
	Maxim Levitsky

