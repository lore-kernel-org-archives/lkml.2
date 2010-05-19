Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab0ESU57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 16:57:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751383Ab0ESU56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 16:57:58 -0400
Date: Wed, 19 May 2010 13:57:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Adds ratelimit_state_init()
Message-Id: <20100519135754.17afd645.akpm@linux-foundation.org>
In-Reply-To: <87k4r3cqgz.fsf@devron.myhome.or.jp>
References: <87k4r3cqgz.fsf@devron.myhome.or.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 May 2010 09:38:20 +0900
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:

> Andrew, this is the part of fatfs error ratelimit. I.e. fatfs change is
> depending to this patch.
> 
> I guess this area usually is sent to you. But, if this patch
> wasn't applied before fatfs change, fatfs will break.
> 
> Well, so, can I pass fatfs patch to you? Or, I should apply this to
> fatfs-tree too?

Is OK, I'll send them both in for 2.6.35, thanks.
