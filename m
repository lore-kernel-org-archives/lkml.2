Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750921Ab1HXEAR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 00:00:17 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39192 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab1HXEAO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 00:00:14 -0400
MIME-Version: 1.0
In-Reply-To: <20110824035800.GA30312@redhat.com>
References: <CAFWT=833UrQ0irJfL5z=6R97+wd4ewW9Cd88maeXhZ_95aMhsw@mail.gmail.com>
	<20110824035800.GA30312@redhat.com>
Date: Wed, 24 Aug 2011 00:00:13 -0400
Message-ID: <CAFWT=829mqzfzdXDEFcbno0zJh+EARmdmsjx6H5-Ju5Pqm2CrA@mail.gmail.com>
Subject: Re: Bug Report for Linux Kernel 3.x
From: Steevven1 <steevven1@gmail.com>
To: Dave Jones <davej@redhat.com>, Steevven1 <steevven1@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the comment. I have already tried this with several
different 3-series kernels. There was no effect on power consumption
or output from powertop.

SK!


On Tue, Aug 23, 2011 at 11:58 PM, Dave Jones <davej@redhat.com> wrote:
> On Tue, Aug 23, 2011 at 07:19:35PM -0400, Steevven1 wrote:
>  > Hello,
>  >
>  > I would like to report what myself and several others believe to be a
>  > serious bug affecting all Linux kernels 3.0 and up, and none below 3.0
>  > (2.6.x and lower).
>  >
>  > One-sentence description: On certain hardware, the 3.x series kernels
>  > drain a considerable amount more power than the 2.6-series kernels, up
>  > to 40% more, even when idle.
>  >
>  > The specific hardware I have personally tested is a Lenovo ThinkPad
>  > X220 with an Intel SandyBridge i7 2620M processor.
>
> Sounds like https://bugzilla.redhat.com/show_bug.cgi?id=727579
> Try booting with i915.i915_enable_rc6=1
>
>        Dave
>
>
