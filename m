Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab2BMIxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 03:53:04 -0500
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:6241 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751012Ab2BMIxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 03:53:03 -0500
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host q1D8p3uX000766
Subject: Re: Does the mq_timedreceive() fully implement the POSIX
 specification?
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: K K <knewsgroup@gmail.com>
Cc: kernelnewbies@kernelnewbies.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Feb 2012 09:51:04 +0100
In-Reply-To: <CAEv6XcdzB++iZX4qAzmQYCJwfspXAHB01qEQoS+G2+8F+bm5Zg@mail.gmail.com>
References: <CAEv6XcdzB++iZX4qAzmQYCJwfspXAHB01qEQoS+G2+8F+bm5Zg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1329123064.25984.303.camel@thorin>
Mime-Version: 1.0
X-DCC-wuwien-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Mon, 2012-02-13 at 10:30 +0800, K K wrote:
[....]
> I am doing POSIX test on linux. And for mq_timedreceive() in POSIX spec
> 2008 Issue 7, Line 43787:
> 
>   The validity of the abstime parameter need not be checked if a
>   message can be removed from the message queue immediately.
> 
> But when I run test case mq_timedreceive/10-2 of POSIX suite (can be viewed
> at :
> http://ltp.git.sourceforge.net/git/gitweb.cgi?p=ltp/ltp.git;a=blob;f=testcases/open_posix_testsuite/conformance/interfaces/mq_timedreceive/10-2.c;h=49ee4f243fc5046a965a551650d8697217faac35;hb=HEAD),
> mq_timedreceive() could get the message without wait, but the timeout is
> still validated.
> 
> Do we intend to do so, or the implementation needs update?

I'm not a native English speaker but there is IMHO no problem as the
above quoted part of POSIX simply does not require the check in that
case. But it doesn't forbid the check.

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

