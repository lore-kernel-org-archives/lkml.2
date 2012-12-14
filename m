Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab2LNALi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 19:11:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872Ab2LNALh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 19:11:37 -0500
Subject: Re: linux-next: build failure after merge of the final tree (tty
 tree related)
From: Steven Rostedt <srostedt@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20121213233835.GA515@kroah.com>
References: <20121127004948.6e7973525843529de827ed0e@canb.auug.org.au>
	 <1353940512.22512.38.camel@fedora>
	 <20121127100530.20174586b57ef55da58608d4@canb.auug.org.au>
	 <20121214103256.ce307015fd09961ad82346f9@canb.auug.org.au>
	 <20121213233835.GA515@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Thu, 13 Dec 2012 19:11:29 -0500
Message-ID: <1355443890.22512.48.camel@fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-13 at 15:38 -0800, Greg KH wrote:

> Ugh, can someone send me a patch to forward to Linus to fix this please?
> Steven, how about fixing the problem properly?

Yeah, ugh, I should have sent the fix earlier :-(

I've just been hammering at bugs for the people that pay me ;-)

OK, I'll whip up a patch that should at least fix the issue for the time
being.

-- Steve


