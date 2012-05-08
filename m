Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab2EHIcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 04:32:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45742 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab2EHIcG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 04:32:06 -0400
Message-ID: <1336465907.16236.14.camel@twins>
Subject: Re: [PATCH] UBI: Replace yield() with cond_resched()
From: Peter Zijlstra <peterz@infradead.org>
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, dedekind1@gmail.com, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org
Date: Tue, 08 May 2012 10:31:47 +0200
In-Reply-To: <1336465602-12627-1-git-send-email-richard@nod.at>
References: <1336465602-12627-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-08 at 10:26 +0200, Richard Weinberger wrote:
> The comment above yield()'s definition says:
>  * If you want to use yield() to wait for something, use wait_event().
>  * If you want to use yield() to be 'nice' for others, use cond_resched().
>  * If you still want to use yield(), do not!

Oh wow, someone actually reads comments, sweet!!
