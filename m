Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566Ab0CXSKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 14:10:18 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:40191 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932415Ab0CXSKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 14:10:16 -0400
Subject: Re: [pnfs] [GIT BISECT] first bad commit: 1f36f774 Switch !O_CREAT
 case to use of do_last()
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1269453756.5982.33.camel@localhost.localdomain>
References: <4BAA3493.1030802@panasas.com>
	 <20100324160037.GP30031@ZenIV.linux.org.uk>	<4BAA3828.2070506@panasas.com>
	 <20100324160754.GQ30031@ZenIV.linux.org.uk>	<4BAA398C.5050901@panasas.com>
	 <20100324163948.GR30031@ZenIV.linux.org.uk>	<4BAA48A3.1030801@panasas.com>
	 <4BAA4CAC.6060104@panasas.com>  <4BAA5035.1060906@panasas.com>
	 <1269453756.5982.33.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 14:10:08 -0400
Message-ID: <1269454208.5982.34.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 12 msgs/h 2 sum rcpts/h 13 sum msgs/h 2 total rcpts 2611 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 1165A710A154C02F0A6547B91C8571BE0DFEC227
X-UiO-SPAM-Test: remote_host: 130.129.30.233 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 2 total 6 max/h 2 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-24 at 14:02 -0400, Trond Myklebust wrote: 
> I'd say you have a corruption issue either on the server side or on your
> client.

By the way. Does this issue happen with NFSv4 too, or is it only
NFSv4.1?

Trond

