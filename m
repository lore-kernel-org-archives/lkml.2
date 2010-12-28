Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab0L1UWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 15:22:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46485 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900Ab0L1UWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 15:22:20 -0500
Message-ID: <4D1A46D2.1000702@zytor.com>
Date: Tue, 28 Dec 2010 12:21:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 0/3] memblock related top down
References: <4D0C072D.1040201@kernel.org>
In-Reply-To: <4D0C072D.1040201@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2010 04:58 PM, Yinghai Lu wrote:
> Please check
> 
> Those three patches to make memblock allocation more top to down.
> 

Please explain what you mean with "more top to down".  Not what the code
does, but what is the goal of the patchset.

	-hpa
