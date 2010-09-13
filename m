Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab0IMPxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 11:53:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20991 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab0IMPxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 11:53:07 -0400
Date: Mon, 13 Sep 2010 08:51:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Thomas Renninger <trenn@suse.de>,
        Jason Baron <jbaron@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the final tree
 (driver-core tree related)
Message-Id: <20100913085155.6b73c9cc.randy.dunlap@oracle.com>
In-Reply-To: <20100907023404.GA11972@kroah.com>
References: <20100907115426.fc0c3e13.sfr@canb.auug.org.au>
	<20100907023404.GA11972@kroah.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Sep 2010 19:34:04 -0700 Greg KH wrote:

> On Tue, Sep 07, 2010 at 11:54:26AM +1000, Stephen Rothwell wrote:
> > Hi Greg,
> > 
> > After merging the final tree, today's linux-next build (powerpc
> > allnoconfig) produced this warning:
> > 
> > kernel/params.c: In function 'parse_args':
> > kernel/params.c:233: warning: the frame size of 1032 bytes is larger than 1024 bytes
> > 
> > Introduced by commit 32e6407e9361cd1aac39ff6b744cad48d1802a08 ("Dynamic
> > Debug: Introduce global fake module param module.ddebug") which added a
> > 1024 byte array to the stack ...
> 
> Wierd, why didn't this show up yesterday?  The patch was in that tree
> then, right?
> 
> Thomas, care to fix this up?


ping.  Is Thomas around??

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
