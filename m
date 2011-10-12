Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab1JMAu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 20:50:26 -0400
Received: from ozlabs.org ([203.10.76.45]:51304 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404Ab1JMAuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 20:50:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <htejun@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] lguest: move process freezing before pending signals check
In-Reply-To: <20111012065504.GC31570@tiehlicka.suse.cz>
References: <cover.1317110948.git.mhocko@suse.cz> <e213ea00900cba783f228eb4234ad929a05d4359.1317110948.git.mhocko@suse.cz> <20111012065504.GC31570@tiehlicka.suse.cz>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Thu, 13 Oct 2011 10:27:07 +1030
Message-ID: <87lispepbg.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Oct 2011 08:55:04 +0200, Michal Hocko <mhocko@suse.cz> wrote:
> Hi Rusty,
> what is the current state of this patch? Are you planning to push it for
> 3.2?

Oh.  Having acked it, I assumed you'd push.  But I've put it in my queue
now.

Thanks,
Rusty.
