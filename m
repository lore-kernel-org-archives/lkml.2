Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab0LQNUz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 08:20:55 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45413 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab0LQNUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 08:20:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=KAwk9qx1GFo8pbZ5C5gccZCTskIzpL8ETUzi2Y/Z3MYj68o5P0aYC68MGE9pbz+b2o
         a7ERCwmQrTvkM49YmMjzOkIurHV9gFrxZv0Ni8qUVBl5ZfLlbOVJyLdo6OwAeB+D4/Ys
         KrSV77wKgUm96+FW53daemv+++K9O/EDBaeNE=
Date: Fri, 17 Dec 2010 16:20:37 +0300
From: Dan Carpenter <error27@gmail.com>
To: Xenofon Foukas <foukas.xenofon@gmail.com>
Cc: gregkh@suse.de, john.d.sheehan@gmail.com, u.kleine-koenig@pengutronix.de,
        arun.thomas@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Fix checkpatch issues in file s626.c
Message-ID: <20101217132037.GK1639@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Xenofon Foukas <foukas.xenofon@gmail.com>, gregkh@suse.de,
	john.d.sheehan@gmail.com, u.kleine-koenig@pengutronix.de,
	arun.thomas@gmail.com, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1292575893-17677-1-git-send-email-foukas.xenofon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292575893-17677-1-git-send-email-foukas.xenofon@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 10:51:33AM +0200, Xenofon Foukas wrote:
> This patch fixes line over 80 characters warnings
> in file s626.c

I don't really think it's worthwhile to do this.  In my opinion, the
original long lines are more readable than the new ones.

Long lines are a bad thing because they show that the coders don't know
what they are doing.  But chopping the lines into smaller lines is like
painting over a person who has small pox.  It doesn't fix the problem.

There are a couple other problems with this patch.

The subject should say:
[PATCH 2/2] Staging: comedi: Fix checkpatch issues in file s626.c

The patch changes places that say:
	DEBUG("foo");
to:
	printk(KERN_DEBUG "foo");

The trick with the DEBUG() macro is that it normally doesn't print
anything by default because it's compiled out.  This patch makes it
compiled in always.

You didn't describe that change in the changelog.

Also the indenting in the new patch isn't always the right.  The
multi-line commenting style isn't right.

regards,
dan carpenter

