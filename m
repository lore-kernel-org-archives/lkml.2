Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab2K2J00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 04:26:26 -0500
Received: from mail.skyhub.de ([78.46.96.112]:60605 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553Ab2K2J0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 04:26:24 -0500
Date: Thu, 29 Nov 2012 10:26:21 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ian Kumlien <pomac@vapor.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] NULL pointer dereference in 3.7-rc7 (syscall_trace_enter)
Message-ID: <20121129092621.GA21100@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ian Kumlien <pomac@vapor.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1354144802.5396.3.camel@pi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1354144802.5396.3.camel@pi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 12:20:02AM +0100, Ian Kumlien wrote:
> Hi, 
> 
> Due to unexplained dns problems, I'll be using google plus to post the
> photo of the bug output.
> 
> https://plus.google.com/photos/110698868656495230656/albums/5816005854482735041
> 
> I'm sorry but my knowledge is limited and current caffeine level is low,
> so I'm offloading to someone who has these things handled ;)

Hmm, this looks strange, were you doing any system tracing or similar?
How reproducible is this? If you can reliably reproduce it, can you
make a much more readable screen photo of it so that one can read all
register values and the "Code:" section in the backtrace is complete and
also readable?

Thanks.

-- 
Regards/Gruss,
    Boris.
