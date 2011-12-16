Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759922Ab1LPO6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 09:58:44 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:35229 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab1LPO6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 09:58:35 -0500
Subject: Re: unexpected taint message
From: Johannes Berg <johannes@sipsolutions.net>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Arend van Spriel <arend@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20111216144804.GA11693@elliptictech.com>
References: <4EEB0EFC.5000302@broadcom.com>
	 <1324038636.3429.1.camel@jlt3.sipsolutions.net>
	 <4EEB4D61.80602@lwfinger.net>
	 <1324043939.3429.2.camel@jlt3.sipsolutions.net>
	 <20111216144804.GA11693@elliptictech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Dec 2011 15:58:31 +0100
Message-ID: <1324047511.3429.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-16 at 09:48 -0500, Nick Bowler wrote:
> On 2011-12-16 14:58 +0100, Johannes Berg wrote:
> > Hmm. I wish OOT didn't disable lockdep, we do a lot of development with
> > modules OOT because the turnaround is faster/easier (for not so
> > experienced developers). Worst case we can patch it out of the base
> > kernel I guess...
> 
> Indeed, but the good news is that we should finally be able to put this
> issue behind us soon(ish).
> 
>   https://git.kernel.org/?p=linux/kernel/git/tip/tip.git;a=commit;h=9ec84acee1e221d99dc33237bff5e82839d10cc0

Oh. I just sent almost the same patch, oops!

johannes

