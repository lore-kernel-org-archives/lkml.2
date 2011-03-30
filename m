Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab1C3Nts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 09:49:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64981 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab1C3Ntr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 09:49:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LDeHA5mCbtvsSB5LOwzw3fg9rDh3AuIH868zP9DDJwyxc0nMpoIlS+n52K/l6DlVpw
         Mnf8+ol3n+rhwCwQ5tiam540g+PMRRR8gIGXB1+5aQHTxVs2dfhB4Zciu3QP5yuZOgG3
         3FHBbzWx6GvG9M9uNUdaZDmn7qBTQYPCaToII=
Date: Wed, 30 Mar 2011 15:49:42 +0200
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] block: eliminate ELEVATOR_INSERT_REQUEUE
Message-ID: <20110330134942.GG17523@htj.dyndns.org>
References: <20110326042156.GB28458@redhat.com>
 <20110328082321.GC16530@htj.dyndns.org>
 <20110328221547.GA1118@redhat.com>
 <x49y63yvwum.fsf@segfault.boston.devel.redhat.com>
 <20110329175458.GE24485@redhat.com>
 <20110330074123.GA17523@htj.dyndns.org>
 <20110330075752.GC17523@htj.dyndns.org>
 <4D92E2CD.6000909@kernel.dk>
 <20110330080203.GD17523@htj.dyndns.org>
 <20110330134658.GB1291@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110330134658.GB1291@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Mar 30, 2011 at 09:46:58AM -0400, Vivek Goyal wrote:
> With ordering semantics gone, do we still need to drain the elevator
> before queuing flush at the end of request queue.

No, not at all, which was why I was cheating with front insertion.
Anyways, with Jens' patch posted in this thread, this is no longer a
problem.

Thanks.

-- 
tejun
