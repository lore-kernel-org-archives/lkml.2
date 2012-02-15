Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416Ab2BOATL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 19:19:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43622 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537Ab2BOATJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 19:19:09 -0500
Date: Tue, 14 Feb 2012 16:19:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] prio_tree: remove unnecessary code in
 prio_tree_replace
Message-Id: <20120214161908.3fbc2c27.akpm@linux-foundation.org>
In-Reply-To: <4F3A2285.7060700@linux.vnet.ibm.com>
References: <4F3A2285.7060700@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Feb 2012 16:59:49 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> Remove the code since 'node' has already been initialized in the
> begin of the function
> 

The patches look good to me.

You appear to be the first person to touch this code in seven years. 
That must be a world record.

