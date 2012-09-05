Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230Ab2IETG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 15:06:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35620 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab2IETGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 15:06:25 -0400
Date: Wed, 5 Sep 2012 12:03:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org, konrad.wilk@oracle.com,
        sjenning@linux.vnet.ibm.com, minchan@kernel.org
Subject: Re: [PATCH 1/3] staging: ramster: remove old driver to prep for new
 base
Message-ID: <20120905190351.GA21131@kroah.com>
References: <1346366764-31717-1-git-send-email-dan.magenheimer@oracle.com>
 <1346366764-31717-2-git-send-email-dan.magenheimer@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346366764-31717-2-git-send-email-dan.magenheimer@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 03:46:02PM -0700, Dan Magenheimer wrote:
> To prep for moving the ramster codebase on top of the new
> redesigned zcache2 codebase, we remove ramster (as well
> as its contained diverged v1.1 version of zcache) entirely.

This patch fails to apply on top of my staging-next tree :(

Care to refresh it, keep Konrad's ack, and resend all 3?

thanks,

greg k-h
