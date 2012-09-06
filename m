Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760069Ab2IFAJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 20:09:44 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:59771 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182Ab2IFAJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 20:09:43 -0400
Date: Wed, 5 Sep 2012 17:07:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org, konrad.wilk@oracle.com,
        sjenning@linux.vnet.ibm.com, minchan@kernel.org
Subject: Re: [PATCH 2/3] staging: ramster: move to new zcache2 codebase
Message-ID: <20120906000708.GA13754@kroah.com>
References: <1346877901-12543-1-git-send-email-dan.magenheimer@oracle.com>
 <1346877901-12543-3-git-send-email-dan.magenheimer@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346877901-12543-3-git-send-email-dan.magenheimer@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 01:45:00PM -0700, Dan Magenheimer wrote:
> [V2: rebased to apply to 20120905 staging-next, no other changes]

You do realize this patch introduces build warnings, right?

Hopefully you will fix that up soon (i.e. really soon...)

greg k-h
