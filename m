Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab1DSTdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 15:33:15 -0400
Received: from mail6.webfaction.com ([74.55.86.74]:44847 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab1DSTdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 15:33:14 -0400
Subject: Re: [PATCH] extra/1 Allow setting the maximum KBUS message size
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Tony Ibbs <tibs@tonyibbs.co.uk>
In-Reply-To: <20110418140110.GD9462@sirena.org.uk>
Date: Tue, 19 Apr 2011 20:33:07 +0100
Cc: Jonathan Corbet <corbet@lwn.net>, Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux-embedded <linux-embedded@vger.kernel.org>,
        Tibs at Kynesim <tibs@kynesim.co.uk>,
        Richard Watts <rrw@kynesim.co.uk>,
        James Chapman <jchapman@katalix.com>
Content-Transfer-Encoding: 7bit
Message-Id: <8A323683-36E6-464E-91DC-AD30CA84C1E0@tonyibbs.co.uk>
References: <cover.1300450604.git.tibs@tonyibbs.co.uk> <20110322133640.5d5c88e4@bike.lwn.net> <DBA665CD-BE12-4DC8-9B3F-4170BED789BD@tonyibbs.co.uk> <32934D05-E7A7-4A2C-92EF-96A0580F2234@tonyibbs.co.uk> <20110415164608.489d82bf@bike.lwn.net> <20110418140110.GD9462@sirena.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 18 Apr 2011, at 15:01, Mark Brown wrote:

> On Fri, Apr 15, 2011 at 04:46:08PM -0600, Jonathan Corbet wrote:
> 
>> That means getting more people to look at the patch, which could be hard.
>> The problem is that, if you wait, they'll only squeal when the code is
>> close to going in, and you could find yourself set back a long way.  A
>> good first step might be to CC Andrew Morton on your next posting.
> 
> One other thing that it'd be good to see is a contrast and compare with
> other similar things like the Android binder that are floating around.

I'm aiming to write a smallish example of using KBUS for something not
entirely boring, and that will hopefully work as a starting point for
comparisons. Unfortunately (for this purpose, anyway), the next couple
of weekends (including four days of public holiday!) are taken up with
other things, so it will be a little while.

That will probably be an appropriate thing to CC Andrew Morton.

Comparative examples of how to do something similar with other means may
take longer, of course.

Thanks,
	Tibs
