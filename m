Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab0CYSSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 14:18:40 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:60030 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754Ab0CYSSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 14:18:39 -0400
Subject: Re: [pnfs] [GIT BISECT] first bad commit: 1f36f774 Switch !O_CREAT
 case to use of do_last()
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Benny Halevy <bhalevy@panasas.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Doug Nazar <nazard.lkml@gmail.com>
In-Reply-To: <4BABA609.3060408@panasas.com>
References: <20100325101231.GU30031@ZenIV.linux.org.uk>
	 <20100325105406.GW30031@ZenIV.linux.org.uk> <4BAB51F5.609@panasas.com>
	 <4BAB54B0.3080109@panasas.com> <20100325130610.GZ30031@ZenIV.linux.org.uk>
	 <4BAB656E.8020204@panasas.com> <20100325133746.GA30031@ZenIV.linux.org.uk>
	 <4BAB6911.5020009@panasas.com> <20100325140457.GB30031@ZenIV.linux.org.uk>
	 <4BAB72C1.6090002@panasas.com> <20100325152505.GD30031@ZenIV.linux.org.uk>
	 <4BAB9D53.4000909@panasas.com>
	 <1269539981.3648.31.camel@localhost.localdomain>
	 <4BABA609.3060408@panasas.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Mar 2010 14:18:32 -0400
Message-ID: <1269541112.3648.48.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 13 msgs/h 2 sum rcpts/h 18 sum msgs/h 2 total rcpts 2651 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: F8A30514F3D25295310D414B2B3C18A40146E620
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 2 total 266 max/h 7 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-25 at 20:06 +0200, Boaz Harrosh wrote: 
> On 03/25/2010 07:59 PM, Trond Myklebust wrote:
> > Now to understand that screwed up xdr decode...
> > 
> 
> Tell me if you need that I run any tests. I still have that
> failing setup if you need it.

Do you have a wireshark (binary) dump that includes that particular
getattr call and reply? That would help.

Trond

