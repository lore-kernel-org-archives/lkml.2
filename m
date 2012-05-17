Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761977Ab2EQOlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 10:41:17 -0400
Received: from mail.tpi.com ([70.99.223.143]:3739 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761074Ab2EQOlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 10:41:15 -0400
Message-ID: <4FB50E1E.8020202@canonical.com>
Date: Thu, 17 May 2012 08:41:34 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ben Skeggs <skeggsb@gmail.com>
CC: bskeggs@redhat.com, Seth Forshee <seth.forshee@canonical.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: 3.4-rc7 backlight regression on Dell XPS M1710
References: <4FB3EF1C.5040804@canonical.com> <1337214652.22052.1.camel@nisroch> <CACAvsv551Q2Wb=bj6piizN88-+k-wCJS0FgT5j5KiK5N3Se=Gw@mail.gmail.com>
In-Reply-To: <CACAvsv551Q2Wb=bj6piizN88-+k-wCJS0FgT5j5KiK5N3Se=Gw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 12:20 AM, Ben Skeggs wrote:
> On Thu, May 17, 2012 at 10:30 AM, Ben Skeggs<bskeggs@redhat.com>  wrote:
>> Am Mittwoch, den 16.05.2012, 12:17 -0600 schrieb Tim Gardner:
>>> commit b99da31ed8521eb78d5d6930f3128f8ecdb75fae causes the backlight in
>>> my Dell XPS M1710 to stop working. Symptoms are dim display and won't
>>> respond to key brightness events. I bisected and confirmed that
>>> reverting this single patch on top of 3.4-rc7 fixes the problem.
>> That commit is correct, it may have uncovered a bug elsewhere though.
> It's been pointed out I should probably be a bit more verbose about
> what I'm after here... Apologies :)
>
> The commit that causes the original regression is
> a0b25635515ef5049f93b032a1e37f18b16e0f6f.  Did your backlight work
> correctly before this?
>
> Thanks,
> Ben.
>

I just checked that brightness controls worked with the original 2.6.32 
kernel. The original regression commit 
a0b25635515ef5049f93b032a1e37f18b16e0f6f went into 3.3, but the 
backlight for this laptop has continued to function until commit 
b99da31ed8521eb78d5d6930f3128f8ecdb75fae (3.4-rc6).

rtg@m1710:~$ uname -r
2.6.32-41-generic
rtg@m1710:~$ lsmod|egrep ^n
nouveau               515227  2

rtg
-- 
Tim Gardner tim.gardner@canonical.com
