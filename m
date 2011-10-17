Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab1JQLSL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 07:18:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41480 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755524Ab1JQLSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 07:18:09 -0400
Date: Mon, 17 Oct 2011 12:18:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, zdevai@gmail.com
Subject: Re: [PATCH] staging:iio:proof of concept in kernel interface.
Message-ID: <20111017111807.GA27266@opensource.wolfsonmicro.com>
References: <20111013143224.GO1098@sirena.org.uk>
 <4E96F9AC.9000001@cam.ac.uk>
 <20111013204410.GA17160@sirena.org.uk>
 <4E985C60.9020308@cam.ac.uk>
 <CAKnu2MrUkY2upFh5d6GGTNUr-=r_JKcxh5OQNV63bdOCa4F+zg@mail.gmail.com>
 <4E9BF8D9.8030301@cam.ac.uk>
 <20111017101959.GC3042@opensource.wolfsonmicro.com>
 <4E9C0423.5010909@cam.ac.uk>
 <20111017104642.GD3042@opensource.wolfsonmicro.com>
 <4E9C0DD7.7080105@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9C0DD7.7080105@cam.ac.uk>
X-Cookie: Be cautious in your daily affairs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 12:13:27PM +0100, Jonathan Cameron wrote:
> On 10/17/11 11:46, Mark Brown wrote:

> > I think the PMIC case is a real one, assigning numbers people need to
> > use to find things is doesn't really reflect actual usage.

> Just to make sure I'm understanding you correctly could you give an example
> part.  The supplies one we explicitly handle anyway so I'm happy with that
> one, I just want to confirm that this is what you are talking about.

The wm831x PMICs have an AUXADC with (actual wirings vary depending on
the particular device):

 - Some voltage inputs hard wired to particular system supplies.
 - One or more temperature inputs wired to particular place (eg, chip
   and battery).
 - Some channels that measure voltages on some of the pins with no
   particular function allocated to them.
