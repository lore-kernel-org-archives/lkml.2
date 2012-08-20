Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab2HTVzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 17:55:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54877 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683Ab2HTVzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 17:55:02 -0400
Date: Mon, 20 Aug 2012 14:54:58 -0700
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@redhat.com,
        lauro.venancio@openbossa.org, jak@jak-linux.org
Subject: Re: [PATCHSET] workqueue: make all workqueues non-reentrant
Message-ID: <20120820215458.GX24861@google.com>
References: <1344908986-18152-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344908986-18152-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 06:49:40PM -0700, Tejun Heo wrote:
> This patchset enforces WQ_NON_REENTRANT behavior on all workqueues and
> simplifies workqueue API accordingly.

Applied 1-5 to wq/for-3.7.  I'll break up the last patch further and
route it separately.

Thanks.

-- 
tejun
