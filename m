Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380Ab1K3ODl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 09:03:41 -0500
Received: from hera.cwi.nl ([192.16.191.8]:47242 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741Ab1K3ODQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 09:03:16 -0500
Message-ID: <4ED6378A.2030904@cwi.nl>
Date: Wed, 30 Nov 2011 14:02:50 +0000
From: "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86@kernel.org
Subject: Re: kmemleak: unreferenced object in copy_thread
References: <4ED3CE60.2060901@cwi.nl> <CAHkRjk69fwTy0+w4LyXeai5ekCirC1D5V7-Gkja6MbKqJ_-KFw@mail.gmail.com>
In-Reply-To: <CAHkRjk69fwTy0+w4LyXeai5ekCirC1D5V7-Gkja6MbKqJ_-KFw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2011 11:54 AM, Catalin Marinas wrote:
> I can't yet tell whether it's a false positive or not. Did the X
> server die? Is the process with pid 1415 still around? The leaked
> object looks like the thread stack (8K) and it should have been
> removed when the corresponding process was killed.
>

Hi Catalin,

The process was MATLAB. It started swapping because I allocated too big 
an array.

The X server, and all other running applications survived the kill.

I have rebooted the machine since this happend, sorry.

With kind regards,

Wouter
