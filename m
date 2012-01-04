Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab2ADPm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 10:42:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755460Ab2ADPmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 10:42:25 -0500
Date: Wed, 4 Jan 2012 10:42:14 -0500
From: David Teigland <teigland@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] gfs2: make some sizes unsigned in set_recover_size()
Message-ID: <20120104154214.GA8841@redhat.com>
References: <20120104071931.GC30978@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120104071931.GC30978@elgon.mountain>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [patch] dlm: le32 vs le16
> gfs2: make some sizes unsigned in set_recover_size()

Thanks, I've folded in both of those.
Dave

