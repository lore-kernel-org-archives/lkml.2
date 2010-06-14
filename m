Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab0FNTe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 15:34:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754070Ab0FNTeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 15:34:25 -0400
Date: Mon, 14 Jun 2010 12:34:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dave.bueso@gmail.com
Cc: axboe@kernel.dk, jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uniform cdrom: fix mutex unlocking in
 /proc/sys/dev/cdrom/info file
Message-Id: <20100614123417.444a82c3.akpm@linux-foundation.org>
In-Reply-To: <1276102610.5572.32.camel@cowboy>
References: <1276102610.5572.32.camel@cowboy>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jun 2010 12:56:50 -0400
Davidlohr Bueso <dave.bueso@gmail.com> wrote:

> If the last if condition passes the cdrom_mutex mutex will not be unlocked. 
> This patch fixes this and also removes the unnecessary doit label that was only invoked by the done label.
> 

Confused.  There is no way in which cdrom_sysctl_info() can forget to
unlock cdrom_mutex.

