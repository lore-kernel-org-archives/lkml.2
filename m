Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab1ASUzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 15:55:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084Ab1ASUzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 15:55:52 -0500
Date: Wed, 19 Jan 2011 15:55:38 -0500
From: Josef Bacik <josef@redhat.com>
To: Ilya Dryomov <idryomov@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <josef@redhat.com>,
        Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Btrfs: use checksums_len instead of first_page_offset
Message-ID: <20110119205537.GC4050@localhost.localdomain>
References: <20110119191924.GC1358@kwango.lan.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110119191924.GC1358@kwango.lan.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 09:19:24PM +0200, Ilya Dryomov wrote:
> Minimizes the number of (sizeof(u32) * num_checksums) we have to do,
> removes now useless first_page_offset variable.
> 
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>

Reviewed-by: Josef Bacik <josef@redhat.com

Thanks,

Josef
