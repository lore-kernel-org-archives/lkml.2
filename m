Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab2HMQgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 12:36:07 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58653 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab2HMQgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 12:36:06 -0400
Date: Mon, 13 Aug 2012 09:36:01 -0700
From: Tejun Heo <tj@kernel.org>
To: Joonsoo Kim <js1304@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] workqueue: use system_highpri_wq for unbind_work
Message-ID: <20120813163601.GC9180@google.com>
References: <Yes>
 <1344874672-6257-1-git-send-email-js1304@gmail.com>
 <1344874672-6257-5-git-send-email-js1304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344874672-6257-5-git-send-email-js1304@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 01:17:52AM +0900, Joonsoo Kim wrote:
> To speed cpu down processing up, use system_highpri_wq.
> As scheduling priority of workers on it is higher than system_wq and
> it is not contended by other normal works on this cpu, work on it
> is processed faster than system_wq.

Is this from an actual workload?  ie. do you have a test case where
this matters?

Thanks.

-- 
tejun
