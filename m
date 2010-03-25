Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab0CYLzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 07:55:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43177 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab0CYLzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 07:55:18 -0400
Date: Thu, 25 Mar 2010 11:55:14 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Benny Halevy <bhalevy@panasas.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Doug Nazar <nazard.lkml@gmail.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [pnfs] [GIT BISECT] first bad commit: 1f36f774 Switch !O_CREAT
 case to use of do_last()
Message-ID: <20100325115514.GY30031@ZenIV.linux.org.uk>
References: <4BAA4CAC.6060104@panasas.com>
 <4BAA5035.1060906@panasas.com>
 <4BAA52A8.2080304@panasas.com>
 <20100324180622.GS30031@ZenIV.linux.org.uk>
 <4BAA5955.4000001@gmail.com>
 <20100324185604.GT30031@ZenIV.linux.org.uk>
 <4BAB2F5A.30409@panasas.com>
 <20100325101231.GU30031@ZenIV.linux.org.uk>
 <4BAB3967.6000702@panasas.com>
 <20100325104924.GV30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100325104924.GV30031@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 10:49:24AM +0000, Al Viro wrote:

> Does that happen with nfsv3 or is that v4-only?  I'm going to set up v4
> server and client and see what happens, but that information could be
> useful...

*grumble*
I'd managed to forget that rpc.imapd in its infinite wisdom relies on
the FPOS I normally disable.  Oh, well... rebuilding testbox kernel
with dnotify enabled ;-/
