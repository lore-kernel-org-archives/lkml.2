Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab2GRQIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 12:08:43 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:16852 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab2GRQIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 12:08:41 -0400
Date: Wed, 18 Jul 2012 19:07:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Duan Jiong <djduanjiong@gmail.com>
Cc: gregkh@linuxfoundation.org, alan@linux.intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sep_main.c: remove duplicated include
Message-ID: <20120718160726.GB16291@mwanda>
References: <5006C886.80202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5006C886.80202@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject here should have been:

[PATCH] Staging: sep: remove duplicated include

You can find the right subject prefix to use by typing:
git log --oneline filename.c

Also it would have been ok to combine both the sep changes together.
It's just one change even though it's split across two files.  The
vme change is separate because it's in a different module.

regards,
dan carpenter

