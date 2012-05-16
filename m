Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964962Ab2EPBiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 21:38:15 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:36572 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755611Ab2EPBiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 21:38:13 -0400
Date: Wed, 16 May 2012 09:38:02 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Josh Cartwright <joshc@linux.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -rt] mm: protect activate_mm() by
 preempt_[disable|enable]_rt()
Message-ID: <20120516013802.GA8829@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1337061236-1766-1-git-send-email-yong.zhang0@gmail.com>
 <20120515213619.GA8880@joshcartwright.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120515213619.GA8880@joshcartwright.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 05:36:19PM -0400, Josh Cartwright wrote:
> Frank Rowand posted a very similar fix in December of last year that
> we've been carrying to fix the same issue:
> 
>    http://permalink.gmane.org/gmane.linux.kernel/1229806
> 
> It looks like there was some deliberation as to whether or not it should
> be pulled into stable-rt.  Perhaps its time to revisit this discussion?

Yeah, thanks for pointing it out, I didn't know there is discussion about
it.

Thanks again,
Yong
