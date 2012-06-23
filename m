Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab2FWMPh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 08:15:37 -0400
Received: from 28dayslater.mr.itd.umich.edu ([141.211.12.118]:47674 "EHLO
	28dayslater.mr.itd.umich.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751186Ab2FWMPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 08:15:36 -0400
X-Greylist: delayed 900 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Jun 2012 08:15:36 EDT
Date: Sat, 23 Jun 2012 07:51:06 -0400
From: Jim Rees <rees@umich.edu>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: bfields@fieldses.org, Trond.Myklebust@netapp.com,
        akpm@linux-foundation.org, bharrosh@panasas.com,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Vivek Trivedi <t.vivek@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [RFC PATCH] nfs: Support posix_fadvise(POSIX_FADV_RANDOM) on nfs
 server.
Message-ID: <20120623115106.GA2742@umich.edu>
References: <1340448446-10198-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340448446-10198-1-git-send-email-linkinjeon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon wrote:

  From: Namjae Jeon <namjae.jeon@samsung.com>
  
  This patch disable readahead for a file on NFS Server when
  posix_fadvise(fd..., POSIX_FADV_RANDOM) is called on NFS
  Client.

It looks like you're adding an argument to the read op.  Wouldn't that be an
incompatible change?  In which case wouldn't it be better to propose this
for inclusion in NFS 4.2?  In fact didn't Dean propose this?  What ever
happened with that?
