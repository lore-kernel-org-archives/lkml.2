Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664Ab2KXDtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 22:49:31 -0500
Received: from snt0-omc3-s32.snt0.hotmail.com ([65.55.90.171]:55881 "EHLO
	snt0-omc3-s32.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753788Ab2KXDta convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 22:49:30 -0500
Message-ID: <SNT002-W1128F6F94A63B050C01347BC3590@phx.gbl>
X-Originating-IP: [70.79.132.78]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: "mingo@kernel.org" <mingo@kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: RE: [tip:x86/smap] x86-32: Start out eflags and cr4 clean
Date: Fri, 23 Nov 2012 19:49:29 -0800
Importance: Normal
In-Reply-To: <tip-5a5a51db78ef24aa61a4cb2ae36f07f6fa37356d@git.kernel.org>
References: <1348529239-17943-1-git-send-email-hpa@linux.intel.com>,<tip-5a5a51db78ef24aa61a4cb2ae36f07f6fa37356d@git.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 24 Nov 2012 03:49:29.0826 (UTC) FILETIME=[B4EE3420:01CDC9F6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> + * Specifically, cr4 exists if and only if CPUID exists,
> + * which in turn exists if and only if EFLAGS.ID exists.
This may be true for *Intel* 486 CPUs as VME was implemented at the same time as CPUID, but I am not sure that it is true for AMD 486 CPUs.

Yuhong Bao 		 	   		  