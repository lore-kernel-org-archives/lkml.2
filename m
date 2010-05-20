Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab0ETAgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 20:36:21 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:38634 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752942Ab0ETAgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 20:36:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=qzFkaEFBs//Du57aMAmRP3TpFcpHBSL2ZoDyRAz5BqXwPg4b23UeAlII/JoaXswXlSQDy2AjqJz/KOWwZG5dnuHh7kLKEr3IELOLlEwOYHasa7frToo01KGRjVfO10+P;
Date: Wed, 19 May 2010 17:34:49 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@gmail.com>, James Simmons <jsimmons@infradead.org>
Subject: Re: [RFC] Try a bit harder to get output on the screen at panic
 time
Message-ID: <20100519173449.6babbdfa@virtuousgeek.org>
In-Reply-To: <20100409151050.74ef6dcd@virtuousgeek.org>
References: <20100409151050.74ef6dcd@virtuousgeek.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Apr 2010 15:10:50 -0700
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> This set of 3 patches makes it a little more likely we'll get panic
> output onto the screen even when X is running, assuming a KMS enabled
> stack anyway.
> 
> It gets me from a blank or very sparsely populated black screen at
> panic time, to one including the full backtrace and panic output at
> panic time (tested with "echo c > /proc/sysrq-trigger" from an X
> session).
> 
> It doesn't cover every case; for instance I think it'll fail when X has
> disabled the display, but those cases need to be handled with separate
> patches anyway (need to add atomic DPMS paths for instance).
> 
> Anyway, please test these out and let me know if they work for you.

Ping Linus & Dave again.  Have you guys tried these?  Really, it's cool.

-- 
Jesse Barnes, Intel Open Source Technology Center
