Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737Ab1EFVLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 17:11:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932476Ab1EFVLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 17:11:32 -0400
Date: Fri, 6 May 2011 14:11:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, arnd@arndb.de
Subject: Re: Remove last BKL leftover: lock_depth
Message-Id: <20110506141114.10795803.akpm@linux-foundation.org>
In-Reply-To: <1304715928-19266-1-git-send-email-andi@firstfloor.org>
References: <1304715928-19266-1-git-send-email-andi@firstfloor.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  6 May 2011 14:05:24 -0700
Andi Kleen <andi@firstfloor.org> wrote:

> I noticed the BKL task->lock_depth field was there with various users.
> But they all don't need it anymore because the BKL is gone.
> Fix up all the users and then finally remove the field.
> 
> This patchkit only removes code.

Patches in Ingo's tree from Jon Corbet have done this removal.
