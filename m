Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781Ab2HaIhd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 04:37:33 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35877 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315Ab2HaIhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 04:37:31 -0400
Date: Fri, 31 Aug 2012 10:37:28 +0200
From: Borislav Petkov <bp@alien8.de>
To: Marcos Souza <marcos.souza.org@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Get the min and max frequency of a processor
Message-ID: <20120831083727.GA2903@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Marcos Souza <marcos.souza.org@gmail.com>,
	linux-kernel@vger.kernel.org
References: <CAH0vN5Jn1g+zekr-Nd=GizskgbcOGj8zoq+m6OvBiO6Xkw5-UQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAH0vN5Jn1g+zekr-Nd=GizskgbcOGj8zoq+m6OvBiO6Xkw5-UQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 02:48:33PM -0300, Marcos Souza wrote:
> Hi people,
> 
> I'm changing an application to get the min and max frequency of a
> processor. The device is using cpufreq, and it will show the user  the
> min and max frequency that we can overclock.
> 
> There is a way to get these values, instead of reading the /sys files,
> or is this the solution?

What's wrong with using:

/sys/devices/system/cpu/cpu<N>/cpufreq/scaling_available_frequencies

?

-- 
Regards/Gruss,
    Boris.
