Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab2EGTtg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 15:49:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757842Ab2EGTtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 15:49:35 -0400
Subject: Re: [patch 06/18] c6x: Use common threadinfo allocator
From: Mark Salter <msalter@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Mon, 07 May 2012 15:49:25 -0400
In-Reply-To: <20120505150141.621728944@linutronix.de>
References: <20120505150007.543515803@linutronix.de>
	 <20120505150141.621728944@linutronix.de>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1336420166.30472.1.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-05-05 at 15:05 +0000, Thomas Gleixner wrote:
> There is no functional difference. __get_free_pages() ends up calling
> alloc_pages_node().
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Mark Salter <msalter@redhat.com>


