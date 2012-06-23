Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab2FWDA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 23:00:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54567 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab2FWDA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 23:00:57 -0400
Date: Fri, 22 Jun 2012 20:00:52 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 01/10] zcache: fix preemptable memory allocation in
 atomic context
Message-ID: <20120623030052.GA18440@kroah.com>
References: <4FE0392E.3090300@linux.vnet.ibm.com>
 <4FE36D32.3030408@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE36D32.3030408@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 01:51:30PM -0500, Seth Jennings wrote:
> I just noticed you sent this patchset to Andrew, but the
> staging tree is maintained by Greg.  You're going to want to
> send these patches to him.
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>

After this series is redone, right?  As it is, this submission didn't
look ok, so I'm hoping a second round is forthcoming...

thanks,

greg k-h
