Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933247Ab2CZSCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 14:02:47 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56156 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933184Ab2CZSCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 14:02:46 -0400
Date: Mon, 26 Mar 2012 20:02:41 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Daniel Drake <dsd@laptop.org>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        dilinger@queued.net, pgf@laptop.org
Subject: Re: [PATCH v3 resend] x86, olpc: add debugfs interface for EC
 commands
Message-ID: <20120326180241.GA7947@gmail.com>
References: <20120326175229.17E199D401E@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120326175229.17E199D401E@zog.reactivated.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Drake <dsd@laptop.org> wrote:

> Add a debugfs interface for sending commands to the OLPC Embedded
> Controller (EC) and reading the responses.  The EC provides functionality
> for machine identification, battery and AC control, wakeup control, etc.
> 
> Having a debugfs interface available is useful for EC development and
> debugging.
> 
> Based on code by Paul Fox.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>
> Signed-off-by: Paul Fox <pgf@laptop.org>

This is still not valid.

If Paul Fox is the last one in the SOB chain the he is sending 
me the patch - but that's you ...

Thanks,

	Ingo
