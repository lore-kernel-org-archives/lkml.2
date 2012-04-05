Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab2DEWqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 18:46:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53376 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab2DEWq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 18:46:29 -0400
Date: Thu, 5 Apr 2012 15:46:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org,
        David Dajun Chen <Dajun.Chen@diasemi.com>
Subject: Re: [PATCH] LEDS: LED module for DA9052/53 PMIC v2
Message-Id: <20120405154627.bf474920.akpm@linux-foundation.org>
In-Reply-To: <4F621DDE.8010603@metafoo.de>
References: <1329916149.24042.7.camel@dhruva>
	<1331641560.7058.1.camel@dhruva>
	<4F621DDE.8010603@metafoo.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2012 17:50:38 +0100
Lars-Peter Clausen <lars@metafoo.de> wrote:

> On 03/13/2012 01:26 PM, Ashish Jangam wrote:
> > Any update on below patch?
> 
> The patch itself looks good to me. But if David is the author as the C file
> states he should also be the autor of the git commit. You can change the
> author of the git commit for example by running `git commit --amend --author
> 'David Dajun Chen <dchen@diasemi.com>'`.

Some reply to Lars-Peter's email would have been useful.

As drivers/leds/leds-da9052.c contains

 * Author: David Dajun Chen <dchen@diasemi.com>

I rewrote my copy of the changelog so that it lists David as the
primary author.

