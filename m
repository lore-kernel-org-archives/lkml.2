Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147Ab2FOOdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 10:33:11 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40701 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757035Ab2FOOdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 10:33:09 -0400
Date: Fri, 15 Jun 2012 17:33:00 +0300
From: Ido Yariv <ido@wizery.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, shai@scalemp.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/platform] x86/platform: Introduce APIC
 post-initialization callback
Message-ID: <20120615143259.GA2545@WorkStation.localnet>
References: <1338675095-27260-1-git-send-email-ido@wizery.com>
 <tip-7db971b235480849aa5b9209b67b62e987b3181b@git.kernel.org>
 <4FDA208B.2010900@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FDA208B.2010900@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Thu, Jun 14, 2012 at 10:34:03AM -0700, H. Peter Anvin wrote:
> On 06/06/2012 08:01 AM, tip-bot for Ido Yariv wrote:
> > Some subarchitectures (such as vSMP)
> 
> Ido, could you please stop using this formula unless you actually have
> evidence of anything other than vSMP having use for it?  It chronically
> comes across as dishonest.

It was not my intention to disguise vSMP specific features as generic
ones, and I'm sorry if it seemed that way. I assumed other
virtualization architectures might benefit from these features, but at
least initially vSMP is the sole user.

Having said that, I'll be more specific in the future.

Thanks,
Ido.
