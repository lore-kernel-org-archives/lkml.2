Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab1K0KZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 05:25:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37123 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115Ab1K0KZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 05:25:25 -0500
Date: Sun, 27 Nov 2011 01:34:36 -0800
From: Greg KH <gregkh@suse.de>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Evgeniy Polyakov <zbr@ioremap.net>, Josef Bacik <josef@redhat.com>,
        Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 24/62] pohmelfs: remove the second argument of
 k[un]map_atomic()
Message-ID: <20111127093436.GD31631@suse.de>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
 <1322371662-26166-25-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322371662-26166-25-git-send-email-amwang@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 27, 2011 at 01:27:04PM +0800, Cong Wang wrote:
> 
> Signed-off-by: Cong Wang <amwang@redhat.com>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
