Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab1CCAJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 19:09:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657Ab1CCAJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 19:09:36 -0500
Date: Wed, 2 Mar 2011 19:09:32 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "neilb@suse.de" <neilb@suse.de>
Subject: Re: [PATCH 0/3] block: Few fixes for throttle and blk_cleanup_queue()
Message-ID: <20110303000931.GA11538@redhat.com>
References: <1298921130-17533-1-git-send-email-vgoyal@redhat.com>
 <4D6ED971.7040305@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6ED971.7040305@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 06:57:37PM -0500, Jens Axboe wrote:
> On 2011-02-28 14:25, Vivek Goyal wrote:
> > Hi Jens,
> > 
> > These are few fixes for block throtl code and for blk_cleanup_queue(). These
> > should be a good candidate for 2.6.39.
> 
> They look good, thanks.
> 
> A small please to revisit your changelog style. Lets drop the bullet
> points, and it's best to keep at eg 72 chars so that the output is
> readable in git log easily. I sometimes change these for you, would be
> nice if they followed normal style though.

Sure. I will drop bullet style and also limit line width to 72 characters
in future postings.

Do you want me to repost this patch series with changelogs corrected?

Thanks
Vivek
