Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab1DVUKP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 16:10:15 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34389 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910Ab1DVUKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 16:10:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=w++ssQmqRkwFzzpq67Xu5xmeJbfZf5FkurZ2Dkpunok0ugGDkyF6utbTVc9oWMuqJN
         JlD7QeY+ktdITBxzzmKicwhW6gNg99bBvlv3JPAXP2zsTG/leW9ZhCGhcpJg1VZip6cb
         +wgSDp50oqHSzmXdjsfNZjUmPZ7ADbkhK+EZY=
Date: Fri, 22 Apr 2011 15:10:01 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Josef Bacik <josef@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
Message-ID: <20110422200945.GA15387@elie>
References: <1303414954-3315-1-git-send-email-josef@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303414954-3315-1-git-send-email-josef@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Josef Bacik wrote:

> This just gets us ready to support the SEEK_HOLE and SEEK_DATA flags.  Turns out
> using fiemap in things like cp cause more problems than it solves, so lets try
> and give userspace an interface that doesn't suck.  So we have

That's easy to believe, but could you elaborate?  What problem does
using fiemap cause?  I assume the answer is somewhere in somewhere in
the thread

 http://thread.gmane.org/gmane.comp.file-systems.xfs.general/37895/focus=24404

but it would be nice to have a summary in the commit log for
posterity.

Thanks for working on this.
