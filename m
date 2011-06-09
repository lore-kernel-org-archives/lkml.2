Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab1FIXD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 19:03:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40423 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756550Ab1FIXDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 19:03:25 -0400
Date: Fri, 10 Jun 2011 00:03:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: jj@chaosbits.net, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Sparc: Remove trigraph in die_if_kernel() message.
Message-ID: <20110609230322.GY11521@ZenIV.linux.org.uk>
References: <alpine.LNX.2.00.1106071627260.8844@swampdragon.chaosbits.net>
 <20110609.155943.162785602513776337.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110609.155943.162785602513776337.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 03:59:43PM -0700, David Miller wrote:
> > If I'm not mistaken, that "??!" will be taken as a trigraph for "|" by the 
> > preprocessor, so the final string will end up either as
> >   "Penguin instruction from Penguin mode|?!"

Not without -trigraphs, which is not on by default...

> Applied, thanks Jesper :-)

BTW, idiomatic way to deal with those is to use \? instead of string concat...
