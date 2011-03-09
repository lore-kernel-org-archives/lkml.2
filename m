Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab1CIVwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 16:52:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41095 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752694Ab1CIVwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 16:52:47 -0500
Date: Wed, 9 Mar 2011 13:45:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Hong Liu <hong.liu@intel.com>
Subject: Re: [PATCH, RESEND] Putting the device into runtime suspend after
 resume()/probe() is handled
Message-Id: <20110309134504.6d850802.akpm@linux-foundation.org>
In-Reply-To: <20110309123916.19908.78417.stgit@bob.linux.org.uk>
References: <20110309123916.19908.78417.stgit@bob.linux.org.uk>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Mar 2011 12:39:34 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
> Subject: [PATCH, RESEND] Putting the device into runtime suspend after resume()/probe() is handled
> Date: Wed, 09 Mar 2011 12:39:34 +0000
> User-Agent: StGIT/0.14.3
> 
> From: Hong Liu <hong.liu@intel.com>
> 
> by the PM core and the device core code. No need to manually add them in
> each single driver. And correct the runtime state in remove().
> 
> Signed-off-by: Hong Liu <hong.liu@intel.com>
> Signed-off-by: Alan Cox <alan@linux.intel.com>

I'd merged this a while back but was awaiting info on why v1 had a
cc:stable so the changelog could be updated to indicate why a -stable
backport was needed.

I see that the cc:stable has been removed so that settles that.  But
it's still unclear how serious the bugs-which-were fixed are.  Oh well,
a bug's a bug.  I put it in my 2.6.38 queue anyway.
