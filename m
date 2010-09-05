Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab0IETYJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 15:24:09 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53994 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab0IETX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 15:23:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lQfOPi9rxZ4azMg2xPY2tLUWPxtXQ+RbBnmy9HzhCG/20FInJulwp0fvePjGEcktBd
         +NQzhMNIzkpkY6WzdUrBKtrHcr0zlW5aoxLQfaXboCWrYEt2b0cFD1wf1Jn0IHxYIhpZ
         Zm++/SaBY03uHcjii3qufCtzsUZDftUdBf+eY=
Date: Sun, 5 Sep 2010 12:23:53 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Luotao Fu <l.fu@pengutronix.de>, linux-input@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] Input: stmpe-ts - return -ENOMEM if memory
 allocation fail
Message-ID: <20100905192353.GA18411@core.coreip.homeip.net>
References: <1283656244.8339.3.camel@phoenix>
 <20100905052101.GA5797@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100905052101.GA5797@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 05, 2010 at 07:21:01AM +0200, Wolfram Sang wrote:
> On Sun, Sep 05, 2010 at 11:10:44AM +0800, Axel Lin wrote:
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Acked-by: Wolfram Sang <w.sang@pengutronix.de>
> 

Applied, thank you.


-- 
Dmitry
