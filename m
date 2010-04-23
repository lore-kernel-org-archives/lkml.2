Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab0DWGJi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 02:09:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755985Ab0DWGJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 02:09:36 -0400
Date: Thu, 22 Apr 2010 23:07:37 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] Fix a huge latency problem in the MTD CFI and LPDDR
 flash drivers.
Message-Id: <20100422230737.95e441ef.akpm@linux-foundation.org>
In-Reply-To: <1272002584.5347.2.camel@wall-e.seibold.net>
References: <1271623604.7050.0.camel@wall-e.seibold.net>
	<1271787391.16051.4.camel@wall-e.seibold.net>
	<1272002584.5347.2.camel@wall-e.seibold.net>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010 08:03:04 +0200 Stefani Seibold <stefani@seibold.net> wrote:

> David did not respond to my request since more than a month. Can u apply
> the patch to linux next?

The patch is rather too fundamental for there to be benefit in me
carrying it.

Hopefully Artem can look at it soon, although he's somewhat busy with
real-life things at present.

