Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab1GAFoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 01:44:21 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39943 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab1GAFoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 01:44:19 -0400
MIME-Version: 1.0
In-Reply-To: <1308797024.23204.95.camel@debian>
References: <1308797024.23204.95.camel@debian>
Date: Fri, 1 Jul 2011 13:44:19 +0800
Message-ID: <BANLkTimEcPmH_XgLy5aEW+znwJyVZzfoCg@mail.gmail.com>
Subject: Re: power increase issue on light load
From: Ming Lei <tom.leiming@gmail.com>
To: "Alex,Shi" <alex.shi@intel.com>
Cc: ncrao@google.com, peterz@infradead.org, mingo@elte.hu,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 23, 2011 at 10:43 AM, Alex,Shi <alex.shi@intel.com> wrote:
> commit c8b281161dfa4bb5d5be63fb036ce19347b88c63 causes light load
> benchmark use more than 10% system power on platform NHM-EP and laptop
> Thinkpad T410 etc. The benchmarks are specpower and bltk office.
>
> I tried to track this issue, but only find deep C sate time reduced
> much, about from 90% to 30~40%, the C0 or C1 state increase much on
> different machines.
>
> Powertop just hints RES interrupts has a bit more. but when I try "perf
> probe native_smp_send_reschedule". I didn't find much.

I see the problem on -rc5 in my T410 too, the fan has been ringing always
and powertop reports "Wakeups-from-idle per second : 508.6".

thanks,
-- 
Ming Lei
