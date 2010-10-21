Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634Ab0JUPdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 11:33:12 -0400
Received: from enyo.dsw2k3.info ([195.71.86.239]:38037 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757613Ab0JUPdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 11:33:11 -0400
X-Greylist: delayed 524 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Oct 2010 11:33:11 EDT
Date: Thu, 21 Oct 2010 17:24:17 +0200
From: Matthias Schniedermeyer <ms@citd.de>
To: Christian Bahls <lkml@qb352.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ?Powermanagement?-Regression in 2.6.36
Message-ID: <20101021152417.GA16661@citd.de>
References: <AANLkTikR_yZsjqLbVMRQovw1o+v6RVGvjxrwazyw0ZqH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikR_yZsjqLbVMRQovw1o+v6RVGvjxrwazyw0ZqH@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.10.2010 16:34, Christian Bahls wrote:
> Dear List
> 
> PPS: bisecting this regression seems to be out of question
>  recompiling the kernel on this computer takes a few hours
>  as all the other computers i use are 64bit
>  i would alternatively have to setup a cross-compilation environment
>  which i have not done in years (and not without rocklinux either)

As far as it is my experience, x86 32bit/64bit can build each other.

On the "big" machine just add "ARCH=x86" to (all!) make invocations.
ARCH=x86 makes "CONFIG_64BIT" an actual configuration option and 
honours whatever is configured in the .config-file.





Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

