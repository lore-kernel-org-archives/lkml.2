Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab0ENW2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 18:28:34 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54786 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab0ENW2c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 18:28:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=gSvTq6qfcOThCoZnJDau3F/YWeELTpDhbU8sXhMX89c+jmTcYuMtecnV/YYugpCnQs
         08GmU5rTGCnM4I4fALj48m80rvhLCk03yrxx7ZBLitWks70zXVivvVlgavy+29KsgOiG
         UpFWKkACrz+PRVCtUDKLAIzT3/P+yNpSLl48w=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1005142208290.6220@ask.diku.dk>
References: <Pine.LNX.4.64.1005142208290.6220@ask.diku.dk>
Date: Fri, 14 May 2010 15:28:31 -0700
X-Google-Sender-Auth: SrSoUFixpKOLBaoz8LYI1KpIBx0
Message-ID: <AANLkTimeXEaUnzSBuilbQLHj_oho3ia9EgyPGpB7vJRI@mail.gmail.com>
Subject: Re: TSC unstable due to TSC halts in idle?
From: john stultz <johnstul@us.ibm.com>
To: Jesper Dangaard Brouer <hawk@diku.dk>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       netdev <netdev@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Shaohua Li <shaohua.li@intel.com>, hawk@comx.dk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 1:13 PM, Jesper Dangaard Brouer <hawk@diku.dk> wrote:
> I want to know, if its safe to enable the TSC clocksource, when the
> kernel reports:
>  "Marking TSC unstable due to TSC halts in idle"
>
> The system selects HPET (in current_clocksource), but I can still see
> TSC as an available clocksource (in
> /sys/devices/system/clocksource/clocksource0/available_clocksource).
>
> Is it safe to enable TSC manually (by changing current_clocksource)?
> (my workload is 10Git/s routing, cannot survive with a slow clock)
>
>
> Any trick to avoid this? (e.g. kernel config setting, or a /sys/ setting
> which changes the minimum P-state?)

Might try booting with the max-cstate=1 option.

thanks
-john
