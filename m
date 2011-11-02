Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab1KBCzB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 22:55:01 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43384 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753489Ab1KBCzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 22:55:00 -0400
Message-ID: <1320202495.15779.11.camel@Joe-Laptop>
Subject: Re: [PATCH] Stageing: bcm: fixed spacing coding style in
 led_control.c
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, devel@driverdev.osuosl.org,
        Ciaran McCormick <ciaranmccormick@gmail.com>, gregkh@suse.de,
        shemminger@vyatta.com, linux-kernel@vger.kernel.org
Date: Wed, 02 Nov 2011 04:54:55 +0200
In-Reply-To: <20111101202259.GC4682@mwanda>
References: <1320144259-22339-1-git-send-email-ciaranmccormick@gmail.com>
	 <1320145665.14409.149.camel@x61.thuisdomein> <20111101202259.GC4682@mwanda>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-01 at 23:22 +0300, Dan Carpenter wrote:
> You're right that this driver needs a lot of work.
[]
> I'd prefer a series of patches:

Thanks Dan, that's a good summary of useful changes
and their best order.  Couple of comments:

> [patch 1/3] Staging: bcm: fix whitespace in led_control.c
> This would address tabs vs spaces, extra prohibited spaces, and
> spaces required around certain chars.  Also it would add blank lines
> between functions and between declarations and code.

And verify with git diff -w and object diffs.

> [patch 2/3] Staging: bcm: fix C99 comments in led_control.c
> This would fix the 74 ERROR: do not use C99 // comments
> 
> [patch 3/3] Staging: bcm: fix braces style in led_control.c
> This would fix the 70 ERROR: that open brace { should be on the
> previous line.

I'd combine this whitespace change with 1/x myself.

> [patch 1/y] Staging: bcm: Rename "Status" to "ret" in led_control.c
> [patch 2/y] Staging: bcm: Rename CamelCase variables in led_control.c

Dan's rename_review script can help verify this as well.
https://lkml.org/lkml/2011/7/19/196

