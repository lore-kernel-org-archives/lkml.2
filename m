Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab0DOSCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 14:02:13 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:41037 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753395Ab0DOSCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 14:02:12 -0400
Date: Thu, 15 Apr 2010 20:02:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Low-Level and Long-Term Battery Control
Message-ID: <20100415180200.GA1443@ucw.cz>
References: <h2i45cc95261004120628kb38aabecr2552668f9e60d7c5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <h2i45cc95261004120628kb38aabecr2552668f9e60d7c5@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Is there any function in the Linux kernel that control the
> charging/discharging of the battery to provide better lifespan ?
> (add some years to its life ?)

No, I don't think so.

> For Laptops, it is better to extract the battery from the Laptop when
> the computer will be on power for a long period.
> I ask if the kernel can do such control without the user intention and
> in an automatic way.
> 
> Some BIOS provide to the user to select whether to block the battery
> charging to 50% to make it stand for more time.

Where have you seen that?

> And Many people (like me) forget their laptops on power until the
> battery no more can hold energy after 2minutes of no power.
> 
> I am not sure for the MacBook side, but it seems they don't suffer
> from such problem in the same degree as other laptop users.

Normally, smart battery should control charging itself; and it usually
does pretty well.

Exceptions are very small devices such as spitz, but for those
batteries CCCV charging with temperature monitor is usually enough.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
