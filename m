Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab1F3QR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 12:17:56 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49456 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab1F3QRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 12:17:55 -0400
MIME-Version: 1.0
In-Reply-To: <201106301441.24493.arnd@arndb.de>
References: <1309430517-23821-1-git-send-email-s.hauer@pengutronix.de>
	<1309430517-23821-2-git-send-email-s.hauer@pengutronix.de>
	<BANLkTikQGFA7XcuAtEEi7_4m-j6-00sZ6Q@mail.gmail.com>
	<201106301441.24493.arnd@arndb.de>
Date: Thu, 30 Jun 2011 11:17:54 -0500
Message-ID: <BANLkTin_htv2z3D9Bbf6N8Y7UKFRvPtvOg@mail.gmail.com>
Subject: Re: [PATCH 1/3] PWM: add pwm framework support
From: Bill Gatliff <bgat@billgatliff.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        viresh kumar <viresh.kumar@st.com>, Shawn Guo <shawn.guo@linaro.org>,
        Ryan Mallon <ryan@bluewatersys.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guys:

On Thu, Jun 30, 2011 at 7:41 AM, Arnd Bergmann <arnd@arndb.de> wrote:

> A lot of people want to see a framework get merged, and I think it's
> great that Sascha has volunteered to do the work to push that
> through this time, especially since you have not been able to
> finish your work.

Sascha is wasting his time by reinventing the wheel.  He's traveling
over exactly the same path I have already covered.  In fact, some of
his reviewer comments are almost word-for-word the same as those I
have received and addressed in the past.

My patches were always kept current in this mailing list and others,
and Sascha clearly has the skills necessary to make improvements and
corrections should he have chosen to do so.

> What I think would be the best plan forward is to merge Sascha's
> patches as soon as we can, then get all currently existing pwm
> drivers converted to that and moved to drivers/pwm, and finally
> do the interface changes that you have proposed earlier.

That's a real duplication of work.  That makes no sense.

> I would also hope that you can give constructive feedback to
> the submission and point out potential problems that you see
> where the code should be changed now in order to make your
> interface changes more easy later.

My code has already moved past that point.  And if I had the time to
evaluate and improve Sascha's patches, I would have the time to finish
my own.  Sascha is more than welcome to apply his efforts to the
preexisting PWM API patches already present in the LKML archives.

> I realize that it's annoying to spend a lot of time on a specific
> implementation and then see competing code get merged.

Annoyed isn't the word you are looking for.

My code has been reviewed, tested and actively used as posted in LKML
by several reviewers (including myself) in actual hardware.  We are
consciously choosing to discard a known entity and restart the whole
process with new code.  That's a waste of everyone's time and risk
exposure.

I don't consider Sascha's code to be "competing" with mine, as
apparently nobody has bothered to consider one against the other.


> Unfortunately,
> this happens all the time, and the code we merge is often not
> the one that has had the most effort spent on it, but the one that
> looks most promising at the time when it gets merged.

Your definition of "promsing" apparently correlates with "new and shiny".


b.g.
-- 
Bill Gatliff
bgat@billgatliff.com
