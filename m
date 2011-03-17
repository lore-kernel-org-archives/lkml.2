Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab1CQOYD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 10:24:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918Ab1CQOYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 10:24:00 -0400
Date: Thu, 17 Mar 2011 10:23:51 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VFS: remove warning about invalid s_maxbytes values
Message-ID: <20110317102351.1550fa53@barsoom.rdu.redhat.com>
In-Reply-To: <20110317141656.GA28319@infradead.org>
References: <1300371163-23923-1-git-send-email-jlayton@redhat.com>
	<20110317141656.GA28319@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Mar 2011 10:16:56 -0400
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Mar 17, 2011 at 10:12:43AM -0400, Jeff Layton wrote:
> > This warning should have been removed in 2.6.34. We missed that by a
> > few releases, so we should be OK to remove this now.
> 
> Why can't we just kee it?
> 

I suppose we could. It doesn't really harm anything. The idea at the
time was to do this for a few releases and then remove the warning.

If we do that though we should probably fix the comment. Should I just
spin up a patch to do that instead?

-- 
Jeff Layton <jlayton@redhat.com>
