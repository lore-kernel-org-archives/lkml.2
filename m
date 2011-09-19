Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab1ISLT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 07:19:28 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:34027 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab1ISLT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 07:19:27 -0400
Subject: Re: [RFC][PATCH 5/5] target: check hex2bin result
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        andy.shevchenko@gmail.com, safford@watson.ibm.com,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1316204479.12820.394.camel@haakon2.linux-iscsi.org>
References: <1316177430-13167-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1316177430-13167-5-git-send-email-zohar@linux.vnet.ibm.com>
	 <201109162307.FFF57890.OSFOtFLHJQVOMF@I-love.SAKURA.ne.jp>
	 <1316204479.12820.394.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Sep 2011 07:19:17 -0400
Message-ID: <1316431157.3191.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-16 at 13:21 -0700, Nicholas A. Bellinger wrote: 
> On Fri, 2011-09-16 at 23:07 +0900, Tetsuo Handa wrote:
> > Mimi Zohar wrote:
> > > Now that hex2bin does error checking, on error add debugging error msg.
> > 
> > We are waiting for response from Nicholas, aren't we?
> > Quotuing from http://www.spinics.net/linux/fedora/linux-security-module/msg11570.html :
> > | I was assuming that, by adding error check, hex2bin() will leave the buffer
> > | uninitialized in case of bad input because hex2bin() user in Linux 3.0 can
> > | return errors. Now you are a new user of hex2bin() but your code cannot return
> > | errors. Nicholas, how do you want to handle bad input?
> 
> Hi Folks,
> 
> There is another patch queued for v3.1-final to ensure that non hex
> characters are skipped in target_emulate_evpd_83() when building the NAA
> IEEE Registered Extended designator.
> 
> [PATCH-v2] target: Skip non hex characters for VPD=0x83 NAA IEEE Registered Extended
> http://www.spinics.net/lists/target-devel/msg00607.html

Yes, I see.  Nice to have linux-next back.

> Other than dropping this part from Mimi's patch, the two other warning
> messages on conversion failure are OK in target_core_fabric_lib.c code.
> 
> I'm happy to queue a modified version of this one for v3.2.
> 
> --nab

thanks!

Mimi 

