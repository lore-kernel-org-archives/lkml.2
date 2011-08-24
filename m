Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab1HXNZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 09:25:48 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:57177 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab1HXNZo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 09:25:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAFWT=829mqzfzdXDEFcbno0zJh+EARmdmsjx6H5-Ju5Pqm2CrA@mail.gmail.com>
References: <CAFWT=833UrQ0irJfL5z=6R97+wd4ewW9Cd88maeXhZ_95aMhsw@mail.gmail.com>
	<20110824035800.GA30312@redhat.com>
	<CAFWT=829mqzfzdXDEFcbno0zJh+EARmdmsjx6H5-Ju5Pqm2CrA@mail.gmail.com>
Date: Wed, 24 Aug 2011 21:25:43 +0800
Message-ID: <CAAJw_ZsA1h3zza2km6Dj9DUKuWj-3_HTYTGPUgPwpiyphjADhw@mail.gmail.com>
Subject: Re: Bug Report for Linux Kernel 3.x
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Steevven1 <steevven1@gmail.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Your might have  a different issue or perhaps you should make sure
you're up to date with the latest git pull. I'm on
14c62e78dc1379185515be41903c4a667efc6d54 (3.1.0-rc3)

I'm using Lenovo X201s and X was very very unstable and screen freezes
after a while. Now after adding i915.i915_enable_rc6=1, X is running
happily again!!!

Thanks,
Jeff.


On Wed, Aug 24, 2011 at 12:00 PM, Steevven1 <steevven1@gmail.com> wrote:
>
> Thanks for the comment. I have already tried this with several
> different 3-series kernels. There was no effect on power consumption
> or output from powertop.
>
> SK!
>
>
> On Tue, Aug 23, 2011 at 11:58 PM, Dave Jones <davej@redhat.com> wrote:
> > On Tue, Aug 23, 2011 at 07:19:35PM -0400, Steevven1 wrote:
> >  > Hello,
> >  >
> >  > I would like to report what myself and several others believe to be a
> >  > serious bug affecting all Linux kernels 3.0 and up, and none below 3.0
> >  > (2.6.x and lower).
> >  >
> >  > One-sentence description: On certain hardware, the 3.x series kernels
> >  > drain a considerable amount more power than the 2.6-series kernels, up
> >  > to 40% more, even when idle.
> >  >
> >  > The specific hardware I have personally tested is a Lenovo ThinkPad
> >  > X220 with an Intel SandyBridge i7 2620M processor.
> >
> > Sounds like https://bugzilla.redhat.com/show_bug.cgi?id=727579
> > Try booting with i915.i915_enable_rc6=1
> >
> >        Dave
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
