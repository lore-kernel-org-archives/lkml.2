Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab2FNReS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 13:34:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36800 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478Ab2FNReR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 13:34:17 -0400
Message-ID: <4FDA208B.2010900@zytor.com>
Date: Thu, 14 Jun 2012 10:34:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        shai@scalemp.com, tglx@linutronix.de, ido@wizery.com
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/platform] x86/platform: Introduce APIC post-initialization
 callback
References: <1338675095-27260-1-git-send-email-ido@wizery.com> <tip-7db971b235480849aa5b9209b67b62e987b3181b@git.kernel.org>
In-Reply-To: <tip-7db971b235480849aa5b9209b67b62e987b3181b@git.kernel.org>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2012 08:01 AM, tip-bot for Ido Yariv wrote:
> Some subarchitectures (such as vSMP)

Ido, could you please stop using this formula unless you actually have
evidence of anything other than vSMP having use for it?  It chronically
comes across as dishonest.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

