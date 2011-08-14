Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335Ab1HNXyW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 19:54:22 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:61273 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab1HNXyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 19:54:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAF_S4t8gG_28+XYEEUz1=NbA7LqULTByzP93iTE=J927xzYyWg@mail.gmail.com>
References: <CADjdX0dT4Gj=42drL=Trw9Q_Os9To+N_SYjVffZ=0sGeG13uhA@mail.gmail.com>
 <CAF_S4t8gG_28+XYEEUz1=NbA7LqULTByzP93iTE=J927xzYyWg@mail.gmail.com>
From: Michael Witten <mfwitten@gmail.com>
Date: Sun, 14 Aug 2011 23:53:50 +0000
Message-ID: <CAMOZ1BusP7=u6zP+0WL2fW0fD8B9YDmD9sRrR3HXnVBsSQ7Jxg@mail.gmail.com>
Subject: Re: Different concept for drivers?
To: Bryan Donlan <bdonlan@gmail.com>
Cc: Rein Kadastik <pocketpower@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 14, 2011 at 18:36, Bryan Donlan <bdonlan@gmail.com> wrote:
> LWN has an interesting article on the costs of abstraction layers:
> http://lwn.net/SubscriberLink/454716/acf6d97d36960ead/
> Basically, you're limiting yourself to the lowest common denominator
> of OS functionality there, so at the very least you're losing
> performance, and probably functionality as well.

That's really the crux of the issue.

As long as critical code may still easily lift the veil of abstraction
(in well-defined ways!) and tinker around by hand in order to achieve
optimal performance and implement special features, then some kind of
abstraction layer could indeed be very useful in propagating code
quality for at least the lowest common denominator of functionality.

However, it seems more appropriate to provide an API rather than
various DSLs/VMs.
