Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760094Ab2IFAQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 20:16:46 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:43097 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760011Ab2IFAQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 20:16:43 -0400
Date: Wed, 5 Sep 2012 17:14:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org, konrad.wilk@oracle.com,
        sjenning@linux.vnet.ibm.com, minchan@kernel.org
Subject: Re: [PATCH V2 0/3] staging: ramster: move to new zcache2 code base
Message-ID: <20120906001409.GA25879@kroah.com>
References: <1346877901-12543-1-git-send-email-dan.magenheimer@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346877901-12543-1-git-send-email-dan.magenheimer@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 01:44:58PM -0700, Dan Magenheimer wrote:
> [V2: rebased to apply to 20120905 staging-next, no other changes]
> 
> Hi Greg --
> 
> Please apply for staging-next for the 3.7 window to move ramster forward.
> Since AFAICT there have been no patches or contributions from others to
> drivers/staging/ramster since it was merged, this totally new version
> of ramster should not run afoul and the patches should apply to
> your staging-next tree as of 20120905.

All now applied, thanks.

greg k-h
