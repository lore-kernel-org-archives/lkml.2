Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab2DJQYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 12:24:09 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:64789 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab2DJQYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 12:24:07 -0400
Date: Tue, 10 Apr 2012 09:24:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andrew Miller <amiller@amilx.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] Staging: rtl8187se: r8185b_init.c: Fix comment blocks
Message-ID: <20120410162403.GA5753@kroah.com>
References: <1331938060-10207-1-git-send-email-amiller@amilx.com>
 <1331938060-10207-6-git-send-email-amiller@amilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331938060-10207-6-git-send-email-amiller@amilx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 06:47:40PM -0400, Andrew Miller wrote:
> Reformated comment blocks to meet Coding Style

That's good, but note that you also added more coding style violations
when you wrote this patch.

Please ALWAYS run your patches through scripts/checkpatch.pl to keep
this from happening.

I've taken this one for now, but now you have another follow-on patch
that you owe me to fix this one :)

thanks,

gregk -h
