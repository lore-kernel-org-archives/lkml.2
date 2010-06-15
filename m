Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab0FOTMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 15:12:08 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:48730 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932287Ab0FOTME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 15:12:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=CCrTYanautMFf/Di8FKGuWlG4P4GWHxH1hZEI4w4oB1pE/du4KXRhJJf5WeBocriNp
         P1Iou+IHtxJCV7pJj6zG/c6s9PbYGVCd9E3lgC/ZUPYKqplcz3IHHJHN3luahP2Pn5Lq
         toct5JyxkwCMD08WzMG4wkxVu+ZJHaI5ptrdE=
Date: Tue, 15 Jun 2010 21:11:43 +0200
From: Dan Carpenter <error27@gmail.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@google.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] mempolicy:  fix dangling reference to tmpfs superblock
	mpol
Message-ID: <20100615191143.GE5483@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	David Rientjes <rientjes@google.com>,
	Christoph Lameter <cl@linux-foundation.org>
References: <1276624037.5044.47.camel@useless.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276624037.5044.47.camel@useless.americas.hpqcorp.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 01:47:17PM -0400, Lee Schermerhorn wrote:
> Against 2.6.35-rc1+
> 
> My patch to "Factor out duplicate put/frees in mpol_shared_policy_init()
> to a common return path"; and Dan Carpenter's fix thereto both left a
> dangling reference to the incoming tmpfs superblock mempolicy structure.
> A similar leak was introduced earlier when the nodemask was moved offstack
> to the scratch area despite the note in the comment block regarding the
> incoming ref.
> 

Yup.  You're right.

Acked-by: Dan Carpenter <error27@gmail.com>

regards,
dan carpenter
