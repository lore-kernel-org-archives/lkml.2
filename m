Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab1HRQyY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 12:54:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42528 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab1HRQyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 12:54:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAC-yRPShbCYgBiruVQATv8+yqJzaaMGS3skFQe6Gv-KrXKsHXA@mail.gmail.com>
References: <CAC-yRPShbCYgBiruVQATv8+yqJzaaMGS3skFQe6Gv-KrXKsHXA@mail.gmail.com>
From: Amirali Shambayati <amirali.shambayati@gmail.com>
Date: Thu, 18 Aug 2011 21:24:00 +0430
Message-ID: <CAC-yRPQq5An_cHfa8EWFT1zgA8gf=ZRmrzmbws09eNReugaDZg@mail.gmail.com>
Subject: Re: Is it needed to reinstall custom kernel every time, after rebuilding?
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        kernelnewbies@kernelnewbies.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I decided, to first "make all" kernel package and using "dbkg" to
reinstall .deb files every time.
Could it be right?
(re-note: I want to build and install custom kernel for several times!)

On Thu, Aug 18, 2011 at 9:17 PM, Amirali Shambayati
<amirali.shambayati@gmail.com> wrote:
> Hi all,
>
> Last time, I emailed to linux-kernel and kernenewbies mailing-lists
> about how to speed up kernel compilation. I received very useful peace
> of advice about using "ccache". Now I want to modify and compile a
> unique custom kernel several times.
> I used https://help.ubuntu.com/community/Kernel/Compile to compile
> custom kernel. This tutorial uses "kpkg" command to build kernel and
> it produces two .deb files: "linux-image" and "linux-header" as
> result.
> So for the first time I followed this tutorial.
> For next times, according to to experts' advice, I use "make all" in
> custom kernel root directory to rebuild kernel. I am not sure that it
> would be enough to use changed kernel after rebooting. As I asked from
> some experts, It is also required to install kernel again, but they
> were not familiar with "kpkg" and "dbkg",... commands for kernel
> installation.
> Should I use "dbkg" command after every time I rebuild kernel, for
> re-installation?
> If anybody is familiar with these method of kernel installation,
> please help me. It is very urgent, because it is related to my B.S.
> thesis :P
>
> Regards,
>
>
>
> --
> Amirali Shambayati
> Bachelor Student
> Computer Engineering Department
> Sharif University of Technology
> Tehran, Iran
>



-- 
Amirali Shambayati
Bachelor Student
Computer Engineering Department
Sharif University of Technology
Tehran, Iran
