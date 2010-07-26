Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab0GZNyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 09:54:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134Ab0GZNyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 09:54:23 -0400
Date: Mon, 26 Jul 2010 09:54:11 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Heinz Diehl <htd@fancy-poultry.org>, linux-kernel@vger.kernel.org,
        jaxboe@fusionio.com, nauman@google.com, dpshah@google.com,
        guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, czoccolo@gmail.com
Subject: Re: [RFC PATCH] cfq-iosched: IOPS mode for group scheduling and new
 group_idle tunable
Message-ID: <20100726135410.GD12449@redhat.com>
References: <1279834172-4227-1-git-send-email-vgoyal@redhat.com>
 <20100723140343.GA8478@fancy-poultry.org>
 <20100723141303.GB13104@redhat.com>
 <20100723145631.GA8844@fancy-poultry.org>
 <20100723183720.GD13104@redhat.com>
 <20100724080613.GA6554@fancy-poultry.org>
 <20100726134329.GB12449@redhat.com>
 <20100726134818.GA26544@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100726134818.GA26544@infradead.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 09:48:18AM -0400, Christoph Hellwig wrote:
> On Mon, Jul 26, 2010 at 09:43:29AM -0400, Vivek Goyal wrote:
> > > Don't know if this is related, but I'm not quite shure if XFS (which I use
> > > exclusively) uses the jbd/jbd2 journaling layer at all.
> > 
> > I also don't know. But because this patch is making a difference with your
> > XFS file system performance, may be it does use.
> > 
> > CCing Christoph, he can tell us.
> 
> No, of course XFS doesn't use jbd.

Hmm.., interesting. So somewhere WRITE_SYNC idling in CFQ is hurting XFS
performance also. This time for some other reason and not jbd/jbd2.

Vivek


