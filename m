Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194Ab2E3On7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 10:43:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38931 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983Ab2E3On5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 10:43:57 -0400
Message-ID: <4FC631D3.9080907@zytor.com>
Date: Wed, 30 May 2012 07:42:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andre Przywara <andre.przywara@amd.com>
CC: mingo@elte.hu, tglx@linutronix.de, konrad.wilk@oracle.com, jeremy@goop.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        stable@vger.kernel.org.#.3.4+
Subject: Re: [PATCH] x86/amd: fix crash as Xen Dom0 on AMD Trinity systems
References: <1338383402-3838-1-git-send-email-andre.przywara@amd.com>
In-Reply-To: <1338383402-3838-1-git-send-email-andre.przywara@amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 06:10 AM, Andre Przywara wrote:
> Because we are behind a family check before tweaking the topology
> bit, we can use the standard rd/wrmsr variants for the CPUID feature
> register.

That is not what the *msr*_amd*() functions do.

NAK.  This is a totally bogus patch.

	-hpa

