Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab2GJUP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 16:15:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46030 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab2GJUP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 16:15:27 -0400
Date: Tue, 10 Jul 2012 13:15:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org,
        Scan Subscription <scan-subscription@coverity.com>
Subject: Re: [PATCH] kernel: fix mishandling of out of memory in poweroff
Message-Id: <20120710131526.e64cf710.akpm@linux-foundation.org>
In-Reply-To: <20120704153443.4055.53130.stgit@bluebook>
References: <20120704153443.4055.53130.stgit@bluebook>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Jul 2012 16:34:51 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> From: Alan Cox <alan@linux.intel.com>
> 
> Coverity 703573
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>

It would be nice to have a Reported-by here, but we were only given
"Scan Subscription <scan-subscription@coverity.com>".

Is there some human behind these reports?  If so, can that person's
details please be included?

