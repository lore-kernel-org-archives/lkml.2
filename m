Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab0F1UG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 16:06:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54267 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab0F1UGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 16:06:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=RE9VbzBJNdLf0Y+wUw4QEOpTwYyouyV6FgMC4Ie6V+8j6hkHAaBoZsWcqc1FVY6XfD
         cpouFwuSZyr1ACV5fCvSz+hNVViLc1f3wIRtKQKnDv5v3pv2fDLxdkEltwGzkhE0wndW
         muwIcXxlyU0Zl83bK69QQwk0YbTgl7GP3Bg+s=
Date: Tue, 29 Jun 2010 00:06:20 +0400
From: Ilya Loginov <isloginov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] init: Fix race between init and kthreadd -v2
Message-Id: <20100629000620.a7f0a4fe.isloginov@gmail.com>
In-Reply-To: <1277725997.3561.6.camel@laptop>
References: <20100624001148.61e9da1c.isloginov@gmail.com>
	<1277385096.1875.974.camel@laptop>
	<20100624172334.ca7e9bef.isloginov@gmail.com>
	<1277715689.1875.1104.camel@laptop>
	<1277725997.3561.6.camel@laptop>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jun 2010 13:53:17 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> I just realized its all __init code so its all 'free' anyway, how about
> the nicer version:

I will try both versions and write about results. But I think, that there is
some logical inconsistent in these patches (for me). I like v2 more than v1.
But, I would move mutex_lock/unlock. Anyway, I will try your patches first.

Many thanks.

-- 
Ilya Loginov <isloginov@gmail.com>
