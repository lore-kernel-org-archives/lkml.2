Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab0CXSVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 14:21:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753119Ab0CXSVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 14:21:23 -0400
Date: Wed, 24 Mar 2010 11:21:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RFC] #define __BYTE_ORDER
Message-Id: <20100324112106.c8e7b96d.akpm@linux-foundation.org>
In-Reply-To: <1268849455-19503-1-git-send-email-Joakim.Tjernlund@transmode.se>
References: <1268849455-19503-1-git-send-email-Joakim.Tjernlund@transmode.se>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Mar 2010 19:10:55 +0100
Joakim Tjernlund <Joakim.Tjernlund@transmode.se> wrote:

> Linux does not define __BYTE_ORDER in its endian header files
> which makes some header files bend backwards to get at the
> current endian. Lets #define __BYTE_ORDER in big_endian.h/litte_endian.h
> to make it easier for header files that are used in user space too.

I don't get it.  Why not nuke __BYTE_ORDER altogether and do `#ifdef
__LITTLE_ENDIAN' and `#ifdef __BIG_ENDIAN' everywhere?

