Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab0ELAsy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 20:48:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57024 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514Ab0ELAsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 20:48:53 -0400
Message-ID: <4BE9F94A.9000907@zytor.com>
Date: Tue, 11 May 2010 17:41:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Jiri Kosina <trivial@kernel.org>
Subject: Re: [trivial PATCH] arch/x86: Remove unnecessary returns from void
 function()'s
References: <1273624747.20514.316.camel@Joe-Laptop.home>
In-Reply-To: <1273624747.20514.316.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2010 05:39 PM, Joe Perches wrote:
> This patch removes from arch/x86/ all the unnecessary
> return; statements that precede the last closing brace of
> void functions.
> 
> It does not remove returns that are immediately
> preceded by a label as gcc doesn't like that.

And the point of this is?

I fail to see how this improves the clarity of the code one iota, and
isn't anything but just churn.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

