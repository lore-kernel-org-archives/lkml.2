Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab0EKBMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 21:12:32 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:48153 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab0EKBM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 21:12:29 -0400
Subject: Re: PROBLEM: tickless scheduling
From: john stultz <johnstul@us.ibm.com>
To: Donald Allen <donaldcallen@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <AANLkTimnlZYonxKzfGHZTV8vwaDptOPHEPBjNhwnV55Y@mail.gmail.com>
References: <AANLkTin6D2GP0yJJbPYGH1AcAM9-g219rAxSyW_ZlrXV@mail.gmail.com>
	 <AANLkTikjgoBQWqvNxncMUFqWOEXtq4ePvGkvF-m0sGUE@mail.gmail.com>
	 <AANLkTimnlZYonxKzfGHZTV8vwaDptOPHEPBjNhwnV55Y@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 May 2010 18:12:24 -0700
Message-ID: <1273540344.3843.101.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 20:59 -0400, Donald Allen wrote:
> On Mon, May 10, 2010 at 8:54 PM, john stultz <johnstul@us.ibm.com> wrote:
> > On Mon, May 10, 2010 at 5:18 PM, Donald Allen <donaldcallen@gmail.com> wrote:
> >> 1. Network file transfers and fscks stop on Toshiba netbook unless
> >> system receives external events
> >
> > Can you provide /proc/timer_list output?
> 
> Attached, but again, this is from the system running with tickless disabled.

Is it possible to boot with the kernel showing the issue and provide the
details?


> > I assume booting with nohz=off from grub resolves the issue?
> 
> Didn't know about the boot-time option (thanks for pointing it out),
> but I wanted to build a custom kernel anyway, so i did so and disabled
> tickless.

Ok. It may still be of value to know booting with nohz=off does avoid
the problem.


thanks
-john

