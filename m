Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab0CaT1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 15:27:09 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:27384 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905Ab0CaT1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 15:27:07 -0400
X-SpamScore: -34
X-BigFish: VPS-34(zz1432R98dN936eM9371Pzz1202hz4fhz2ba5Mz2fh2a8h6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
Message-ID: <4BB3A1F5.1050902@am.sony.com>
Date: Wed, 31 Mar 2010 12:26:45 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: "swb6@aber.ac.uk" <swb6@aber.ac.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Ftrace and Systemtap
References: <40fe3da502608d32ff82523c57a62da1.squirrel@webmail.aber.ac.uk>
In-Reply-To: <40fe3da502608d32ff82523c57a62da1.squirrel@webmail.aber.ac.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Reverse-DNS: mail7.fw-bc.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2010 10:36 AM, swb6@aber.ac.uk wrote:
> Hi,
> I am currently writing up my
> dissertation based on dynamic tracing and reducing the learning curve to
> understanding the UNIX kernel. I used two dynamic tracing technologies
> (Systemtap and Dtrace) to monitor some virtual machines on a network.
> Whilst going over my initial review of technologies in the area of dynamic
> tracing I realised I had underestimated ftrace, and even dismissed it as
> not being dynamic. However I read hear (http://lwn.net/Articles/343766/)
> that you were as of July last year trying to introduce a patch that would
> allow ftrace the ability to dynamically trace. Also it would be completely
> instrumented from the command line without the need to compile a kernel
> module al la Systemtap.
> 
> My question is do you think Systemtap will be replaced by ftrace in the
> future if so I feel I may need to include this fact in my updated
> technology review.

Systemtap addresses a different set of needs than ftrace.
Ftrace has been dynamic for some time, but in a different way
than Systemtap.

I don't see either system going away soon.

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

