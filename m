Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab2DPVsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 17:48:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38156 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077Ab2DPVsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 17:48:13 -0400
Date: Mon, 16 Apr 2012 14:48:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vsprintf: Correctly handle width when '#' flag used in
 %#p format.
Message-Id: <20120416144810.23761beb.akpm@linux-foundation.org>
In-Reply-To: <1334600274-9436-1-git-send-email-grant.likely@secretlab.ca>
References: <1334600274-9436-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2012 12:17:54 -0600
Grant Likely <grant.likely@secretlab.ca> wrote:

> This patch adjusts the default width of pointer output to include the
> '0x' characters when the '#' flag is included in the format string.

Well that's a bit terse.  What effect does the patch have upon
printk/sprintf/etc behaviour?  The before-and-after thing?

