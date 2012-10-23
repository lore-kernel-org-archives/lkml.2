Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab2JWIs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 04:48:26 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:64301 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756667Ab2JWIsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 04:48:20 -0400
MIME-Version: 1.0
In-Reply-To: <20121022183727.GA31565@kroah.com>
References: <1348733648-13769-1-git-send-email-nitin.dhingra@stericsson.com>
	<20121017212051.GA30879@kroah.com>
	<3ED83A9DB3B6D94CA68BF7C03F2981D35D01B6F1FD@EXDCVYMBSTM006.EQ1STM.local>
	<20121022183727.GA31565@kroah.com>
Date: Tue, 23 Oct 2012 10:48:19 +0200
Message-ID: <CACRpkdb+=RNMzRzWkruZLsq9rtr=2x3vC2DFz9dh5MoybkLLAw@mail.gmail.com>
Subject: Re: [PATCH] staging: Add ST-Ericsson CG2900 driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nitin DHINGRA <nitin.dhingra@stericsson.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Anurag GUPTA-1 <anurag.gupta@stericsson.com>,
        Ingvar PALSSON <ingvar.palsson@stericsson.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Par-Gunnar HJALMDAHL <par-gunnar.hjalmdahl@stericsson.com>,
        Mridul JAIN <mridul.jain@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 8:37 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Oct 18, 2012 at 01:56:00PM +0200, Nitin DHINGRA wrote:
>> > Please refresh my memory, why is this going into drivers/staging/ and
>> > not into the "real" part of the kernel?
>> Putting the code in staging would be convenient so that if there are
>> any design/code suggestions it would be easier to incorporate.
>
> I don't understand.  Have you not tried to submit this code to the
> correct location already?  If not, why not?  If so, what was the result
> of the submission?

That was done by Par-Gunnar some year or two ago.

The reason to why it is being submitted to staging FTM is
that consensus on the transport mechanism over HCI could not be
reached during the patch review.

So my suggestion was to apply it in staging so that these who
want to change that mechanism can show in patches how they
want it to work going forward.

The TODO should include an item such as this:

- Reach consensus on the HCI transport abstraction

Yours,
Linus Walleij
