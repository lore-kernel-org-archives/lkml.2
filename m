Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab1DAGj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 02:39:28 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62025 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab1DAGj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 02:39:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=j6kWTF/GZx5IPINVwm+BueR6toiWUmrBgUka3xBQhngDv/kGpsHraTa2MxHQYd2rIf
         FfyUMOQ/HBxLrzSFnvGba86sfp11elWWnlgWL4mrh8mq+SKlxBFKg9EEHxFnlWtL7M/1
         vt5rpPWNhsOYt5ofrmyuNgO/066D19rRNQTwI=
Date: Fri, 1 Apr 2011 08:39:21 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Aakash Goenka <aakash.goenka@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>,
        Richard Cochran <richard.cochran@omicron.at>,
        Jiri Kosina <jkosina@suse.cz>, Jesper Juhl <jj@chaosbits.net>
Subject: Re: [PATCH] kernel: Fix style problems in time.c
Message-ID: <20110401063921.GA3063@riccoc20.at.omicron.at>
References: <AANLkTi=SegGu5ue=n23e1fhdoZ1jNyTardFJvtAo6vE1@mail.gmail.com>
 <AANLkTinoda73UrHztF4bN_tZNLQyu2qoV5WQT1=J8Rag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinoda73UrHztF4bN_tZNLQyu2qoV5WQT1=J8Rag@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 02:41:16AM +0530, Aakash Goenka wrote:
> I am really sorry, there is a mistake in the patch I sent before.
> Please ignore the last patch and use this instead -
> 
>  Fixes most style errors and warnings. Only left out the ones about
> using include from linux directory instead of asm.

I have been put on CC, but it is not my code. Still, I'll take this
chance to ask, what is the policy regarding patches that only fix
coding style?

(my 2 cents: they spoil annote/blame)

Thanks,
Richard



