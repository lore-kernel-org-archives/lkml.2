Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab0J2GYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 02:24:37 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:40584 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab0J2GYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 02:24:32 -0400
Message-ID: <4CCA685B.1050800@kernel.org>
Date: Thu, 28 Oct 2010 23:23:23 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.14) Gecko/20101013 SUSE/3.0.9 Thunderbird/3.0.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        dilinger@queued.net, tglx@linutronix.de
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/platform] x8: Move olpc to platform
References: <tip-dd191daf06233644a8c5011511e91beb3c598050@git.kernel.org>
In-Reply-To: <tip-dd191daf06233644a8c5011511e91beb3c598050@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2010 05:48 AM, tip-bot for Thomas Gleixner wrote:
> Commit-ID:  dd191daf06233644a8c5011511e91beb3c598050
> Gitweb:     http://git.kernel.org/tip/dd191daf06233644a8c5011511e91beb3c598050
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Sat, 23 Oct 2010 11:28:42 +0200
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Wed, 27 Oct 2010 14:30:02 +0200
> 
> x8: Move olpc to platform

x8?

BTW, are you going to move related code in arch/x86/kernel/apic and arch/x86/pci into arch/x86/platform/xxx?

Thanks
	Yinghai
