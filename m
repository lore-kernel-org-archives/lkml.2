Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207Ab2BMQph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 11:45:37 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:1244 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754835Ab2BMQpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 11:45:36 -0500
X-Mailer: QUALCOMM Windows Eudora Version 7.1.0.9
Date: Mon, 13 Feb 2012 17:45:34 +0100
To: Dave Jones <davej@redhat.com>
From: "N. Coesel" <nico@nctdev.nl>
Subject: Re: Cpufreq shutdown patch (kernel 2.6.35.3)
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20120213162852.GA29947@redhat.com>
References: <CPSMTPM-CMT109lZGdO0011ecc5@CPSMTPM-CMT109.kpnxchange.com>
 <20120213162852.GA29947@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Message-ID: <CPSMTPM-CMT106gqGng00022093@CPSMTPM-CMT106.kpnxchange.com>
X-OriginalArrivalTime: 13 Feb 2012 16:45:34.0681 (UTC) FILETIME=[E8047490:01CCEA6E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

At 17:28 13-2-2012, Dave Jones wrote:
>On Thu, Jan 19, 2012 at 10:18:10PM +0100, N. Coesel wrote:
>
>  > I've found a problem in drivers/cpufreq/cpufreq.c. The driver does
>  > not execute the exit member of the low level driver when shutting
>  > down for a reboot (reset). This potentially leaves the power supply
>  > at a too low voltage to boot the system properly. The patch below
>  > adds a shutdown function which executes the exit member of the low
>  > level driver which allows a system to be properly prepared for a reset.
>
>I'm curious what hardware you saw this problem on ?

This was on an IMX51 embedded platform but I'm quite sure the same 
problem can occur on other platforms as well. There has to be some 
way to allow an orderly shutdown of the low level cpufreq system 
without a cold reset.

Nico Coesel



o---------------------------------------------------------------o
|                       N C T  Developments                     |
|Innovative embedded solutions                                  |
o---------------------------------------------------------------o 

