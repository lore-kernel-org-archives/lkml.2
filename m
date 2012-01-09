Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab2AICJb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 21:09:31 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38143 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab2AICJ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 21:09:28 -0500
Subject: Re: [PATCH] audit: always follow va_copy() with va_end()
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Xi Wang <xi.wang@gmail.com>
In-Reply-To: <139540383.1157551.1326070431707.JavaMail.root@zmail13.collab.prod.int.phx2.redhat.com>
Date: Sun, 8 Jan 2012 21:09:23 -0500
Cc: torvalds@linux-foundation.org, jj@chaosbits.net,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk
Content-Transfer-Encoding: 8BIT
Message-Id: <3D2ADD61-10D1-4155-8B16-19A2BC9105E6@gmail.com>
References: <139540383.1157551.1326070431707.JavaMail.root@zmail13.collab.prod.int.phx2.redhat.com>
To: Eric Paris <eparis@redhat.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 8, 2012, at 7:53 PM, Eric Paris wrote:
> This one was committed to my audit tree which al promised to pull all of my audit tree into the vfs tree for 3.3, so if you want to take it Linus, you can add my ack as the maintainer. I'd expect to see it from Al early this week. Can't say anything about SCSI though...

Could you please also take a look at another simple audit fix or
should I resend the patch again?  Thanks a lot.

https://lkml.org/lkml/2011/12/20/379