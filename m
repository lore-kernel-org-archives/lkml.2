Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab1LTXqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 18:46:11 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50069 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab1LTXqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 18:46:08 -0500
Date: Tue, 20 Dec 2011 15:46:02 -0800
From: Tejun Heo <tj@kernel.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 1/5 V3] cgroup: remove redundate get/put of old css_set
 from migrate
Message-ID: <20111220234602.GP10752@google.com>
References: <1324422873-31001-1-git-send-email-msb@chromium.org>
 <1324422873-31001-2-git-send-email-msb@chromium.org>
 <20111220231823.GK10752@google.com>
 <20111220234131.GV13529@google.com>
 <20111220234259.GO10752@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111220234259.GO10752@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 03:42:59PM -0800, Tejun Heo wrote:
> > But I can stop using scissors if that is what you prefer.
> 
> Heh, that's cute.  If git-am is happy, I'm happy too.  Thanks for
> letting me know.

Hmm... on the second thought, it's not enabled by default and I
suspect git-quiltimport would cut it out.  Let's stick to below --- or
in the commit message.

Thank you.

-- 
tejun
