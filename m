Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746Ab2HGQKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 12:10:09 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60665 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751077Ab2HGQKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 12:10:08 -0400
Message-ID: <1344355807.2026.41.camel@joe2Laptop>
Subject: Re: [PATCH] net:appletalk:ddp:fixed coding style issue again
 relating to
From: Joe Perches <joe@perches.com>
To: Jeffrin Jose <ahiliation@yahoo.co.in>
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org
Date: Tue, 07 Aug 2012 09:10:07 -0700
In-Reply-To: <20120807145738.GA5175@debian.Jeff>
References: <20120807145738.GA5175@debian.Jeff>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-07 at 20:27 +0530, Jeffrin Jose wrote:
> / Is putting "rc = put_user(amount, (int __user *)argp);" on the same
> / indentation level as "amount = skb->len - sizeof(struct ddpehdr);"
> / really what you want to do?

> No. I was trying to place those lines at one
> indentation back from their current position.

If you are using checkpatch as a guide, run
"./scripts/checkpatch.pl -f --strict net/appletalk/ddp.c"
after you patch it and also correct any problems found in
the area you want to update too.

A second option is to use emacs with the proper linux
style indentation.

(See: Documentation/CodingStyle, Chapter 9: You've made a mess of it)

Another option is not to patch the file at all.

Also, don't submit multiple patches, resubmit 1 single patch
with all the appropriate corrections.


