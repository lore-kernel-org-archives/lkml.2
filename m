Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab1GVSJ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 14:09:56 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:51321 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754552Ab1GVSJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 14:09:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=CbBwMIUi2KIypKtjvkvnTu9I5r5OPi40DA9nO2K4EuAnOa4yYrHRwRQzA3gTvC/+gpgi74qIFiS1bEz3y6KFKWzcOKCzziELQNkAe7RwLPzF4axBYCS+Nwd7vgYfBmFm;
Date: Fri, 22 Jul 2011 11:09:52 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Christoph Hellwig <hch@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>,
        Vladimir Zapolskiy <vzapolskiy@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] ptrace changes for v3.1
Message-Id: <20110722110952.fd37cb00.rdunlap@xenotime.net>
In-Reply-To: <20110722180312.GA744@infradead.org>
References: <20110722173237.GA16787@redhat.com>
	<20110722180312.GA744@infradead.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jul 2011 14:03:12 -0400 Christoph Hellwig wrote:

> On Fri, Jul 22, 2011 at 07:32:37PM +0200, Oleg Nesterov wrote:
> > 	- f701e5b7 "connector: add an event for monitoring process tracers" is
> > 	  a bit off-topic, it was routed via ptrace branch because it textually
> > 	  depends on the changes in tracehook/ptrace_attach code.
> 
> Please do not actually add anything to the connector code.  It's a
> horrible interface and users should migrate away from it.

and migrate to  <what>, please??

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
