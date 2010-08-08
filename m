Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab0HHM01 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 08:26:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:50617 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753723Ab0HHM0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 08:26:25 -0400
Message-ID: <4C5EA247.4020508@kernel.org>
Date: Sun, 08 Aug 2010 14:25:43 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: add missing __percpu markup in kernel/workqueue.c
References: <4C5D512A.2070103@kernel.org> <1281189239-14600-1-git-send-email-namhyung@gmail.com>
In-Reply-To: <1281189239-14600-1-git-send-email-namhyung@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 08 Aug 2010 12:26:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2010 03:53 PM, Namhyung Kim wrote:
> works is a percpu pointer but was missing __percpu markup.
> Add it.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Applied to wq#for-linus.  Thanks.

-- 
tejun
