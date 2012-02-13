Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233Ab2BMHqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 02:46:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991Ab2BMHqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 02:46:46 -0500
Message-ID: <1329119196.2647.37.camel@cr0>
Subject: Re: [PATCH 29/60] ecryptfs: remove the second argument of
 k[un]map_atomic()
From: Cong Wang <amwang@redhat.com>
To: Tyler Hicks <tyhicks@canonical.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Dustin Kirkland <dustin.kirkland@gazzang.com>,
        ecryptfs@vger.kernel.org
Date: Mon, 13 Feb 2012 15:46:36 +0800
In-Reply-To: <20120210201605.GC15606@boyd>
References: <1328852421-19678-1-git-send-email-amwang@redhat.com>
	 <1328852421-19678-30-git-send-email-amwang@redhat.com>
	 <20120210201605.GC15606@boyd>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-10 at 14:16 -0600, Tyler Hicks wrote:
> On 2012-02-10 13:39:50, Cong Wang wrote:
> > Signed-off-by: Cong Wang <amwang@redhat.com>
> 
> Thanks - Looks good to me.
> 
> I'm not sure if you want me to pick this up or if you want to continue
> to keep track of the entire pile of patches. Either way, I went ahead
> and pushed it to
> git://git.kernel.org/pub/scm/linux/kernel/git/tyhicks/ecryptfs.git#next

I wanted Andrew to take all of them, but since you already took this
one, Andrew, you don't need to take this one.

Thanks, Tyler!


