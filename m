Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab1K1A6n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 19:58:43 -0500
Received: from matrixpower.ru ([195.178.208.66]:44873 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752215Ab1K1A6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 19:58:42 -0500
Date: Mon, 28 Nov 2011 03:58:37 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Greg KH <gregkh@suse.de>
Cc: Cong Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Josef Bacik <josef@redhat.com>,
        Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 24/62] pohmelfs: remove the second argument of
 k[un]map_atomic()
Message-ID: <20111128005837.GA28109@ioremap.net>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
 <1322371662-26166-25-git-send-email-amwang@redhat.com>
 <20111127093436.GD31631@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111127093436.GD31631@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good!
Although this code is about to die, still worth fixing.
Thank you.

On Sun, Nov 27, 2011 at 01:34:36AM -0800, Greg KH (gregkh@suse.de) wrote:
> On Sun, Nov 27, 2011 at 01:27:04PM +0800, Cong Wang wrote:
> > 
> > Signed-off-by: Cong Wang <amwang@redhat.com>
> 
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

-- 
	Evgeniy Polyakov
