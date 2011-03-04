Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759792Ab1CDPu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 10:50:26 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42240 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab1CDPuZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 10:50:25 -0500
MIME-Version: 1.0
In-Reply-To: <1299204400.2812.35.camel@localhost>
References: <1299204400.2812.35.camel@localhost>
Date: Fri, 4 Mar 2011 10:50:23 -0500
Message-ID: <AANLkTikoSnBZ5E2tD2d5QsLf4DxmQYi0rYtNRvnU8Fmz@mail.gmail.com>
Subject: Re: BUG at mm/mmap.c:2309 when cx18.ko and cx18-alsa.ko loaded
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 3, 2011 at 9:06 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> Hi,
>
> I got a BUG when loading the cx18.ko module (which in turn requests the
> cx18-alsa.ko module) on a kernel built from this repository
>
>        http://git.linuxtv.org/media_tree.git staging/for_v2.6.39
>
> which I beleive is based on 2.6.38-rc2.
>
> The BUG is mmap related and I'm almost certain it has to do with
> userspace accessing cx18-alsa.ko ALSA device nodes, since cx18.ko
> doesn't provide any mmap() related file ops.
>
> So here is my transcription of a fuzzy digital photo of the screen:
<snip>
> I'm not very familiar with mmap() nor ALSA and I did not author the
> cx18-alsa part of the cx18 driver, so any hints at where to look for the
> problem are appreciated.

Hi Andy,

I'm traveling on business for about two weeks, so I won't be able to
look into this right now.

Any idea whether this is some new regression?  I'm just trying to
understand whether this is something that has always been there since
I originally added the ALSA support to cx18 or whether it's something
that is new, in which case it might make sense to drag the ALSA people
into the conversation since there haven't been any changes in the cx18
driver lately.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
