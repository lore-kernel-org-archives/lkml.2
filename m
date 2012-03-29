Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333Ab2C2T0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 15:26:20 -0400
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1279 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab2C2T0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 15:26:15 -0400
From: Maarten ter Huurne <maarten@treewalker.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] /dev/mem: Add kernel config option to omit this device.
Date: Thu, 29 Mar 2012 21:32:29 +0200
Message-ID: <1679935.Pf8rWZIDTT@hyperion>
User-Agent: KMail/4.8.0 (Linux/3.1.9-1.4-default; KDE/4.8.1; x86_64; ; )
In-Reply-To: <4F749C26.60804@zytor.com>
References: <1333041724-20532-1-git-send-email-maarten@treewalker.org> <4F749C26.60804@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 March 2012 10:30:14 H. Peter Anvin wrote:
> On 03/29/2012 10:22 AM, Maarten ter Huurne wrote:
> > Many systems don't need /dev/mem, so make it optional.
> > It saves some space on embedded systems.
> > 
> > Signed-off-by: Maarten ter Huurne <maarten@treewalker.org>
> 
> I would like to see it being modular if it is made optional.  I think
> that would be the right thing anyway.

By modular, do you mean splitting off the code from drivers/char/mem.c into 
a new source file?

In mem.c there are several static functions used by more than one device, 
but I think /dev/mem, /dev/kmem and /dev/port are relatively independent of 
the other devices, so splitting off those three would be an option.

Bye,
		Maarten

