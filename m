Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab0IXQXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:23:35 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34049 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab0IXQXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:23:34 -0400
Date: Fri, 24 Sep 2010 12:20:07 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, eugene@redhat.com,
        linux-kernel@vger.kernel.org, oleg@tv-sign.ru
Subject: Re: [RFC PATCH] proc: making "limits" world readable
Message-ID: <20100924162007.GD30252@hmsreliant.think-freely.org>
References: <1285060255-15784-1-git-send-email-jolsa@redhat.com>
 <20100923145642.49f17b20.akpm@linux-foundation.org>
 <20100924105547.GA1818@jolsa.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100924105547.GA1818@jolsa.brq.redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 12:55:47PM +0200, Jiri Olsa wrote:
> On Thu, Sep 23, 2010 at 02:56:42PM -0700, Andrew Morton wrote:
> > On Tue, 21 Sep 2010 11:10:55 +0200
> > Jiri Olsa <jolsa@redhat.com> wrote:
> > 
> > > hi,
> > > 
> > > I'd like to have the /proc/<pid>/limits file world readable,
> > 
> > Why?
> > 
> 
> having this will ease the task of system management for large install
> bases and where root privileges might be restricted
> 
> jirka
> 
I don't see a problem with making this file world readable.  Doing so would be
in keeping with most of the other stats bearing files in /proc/<pid>.  The only
reason I didn't make it world readable was because the getrlimit sematics
previously kept limit information private to the process, and I didn't want to
deviate from that.  But as long as we're not making it world writeable I think
we're ok.

Acked-by: Neil Horman <nhorman@tuxdriver.com>

