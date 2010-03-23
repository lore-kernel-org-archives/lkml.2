Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab0CWQVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 12:21:48 -0400
Received: from bamako.nerim.net ([62.4.17.28]:55556 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754985Ab0CWQVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 12:21:46 -0400
Date: Tue, 23 Mar 2010 17:21:43 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Jean-Michel Hautbois <jhautbois@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]I2C device - release cleanup
Message-ID: <20100323172143.6b078b2e@hyperion.delvare>
In-Reply-To: <0016e6d64c23d0770e0482776d51@google.com>
References: <20100323135410.47276f58@hyperion.delvare>
	<0016e6d64c23d0770e0482776d51@google.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Mar 2010 13:02:41 +0000, jhautbois@gmail.com wrote:
> Hi Jean,
> 
> < snip >
> > Did you test your patch? I am very skeptical that calling
> 
> > single_release() out of the blue is the right thing to do. My instinct
> 
> > tells me that single_release() is only meant for callers of
> 
> > single_open().
> 
> Well, using this call works fine with my hardware.
> I would say, as before :).
> Looking at the source code of single_release, this is very similar to what  
> is done today.
> 
> But yes, it would also be interesting to use single_open in the open()  
> syscall.
> I think this would be nicer to use only single_*() functions.
> 
> Maybe is it interesting to submit a patch that does a cleanup for all the  
> i2c-dev file ? And not only the release function ?

Yes, that would be better. If you do that, please make sure to run your
patch through scripts/checkpatch.pl before sending it.

-- 
Jean Delvare
