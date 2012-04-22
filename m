Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab2DVXKg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 19:10:36 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:44753 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab2DVXKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 19:10:34 -0400
Date: Mon, 23 Apr 2012 00:13:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mike Snitzer <snitzer@redhat.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        Chandra Seetharaman <sekharan@us.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [SCSI] scsi_dh: change scsi_dh_detach export to
 EXPORT_SYMBOL
Message-ID: <20120423001306.040c512b@pyramind.ukuu.org.uk>
In-Reply-To: <20120422230156.GA25181@redhat.com>
References: <20120405144721.GA18437@redhat.com>
	<20120420144538.GB8155@redhat.com>
	<20120420173405.GA8846@redhat.com>
	<20120420214120.159e2690@pyramind.ukuu.org.uk>
	<20120420215825.GA10406@redhat.com>
	<20120420232043.40ddc3c4@pyramind.ukuu.org.uk>
	<20120420225822.GA10769@redhat.com>
	<20120421001433.2955abd4@pyramind.ukuu.org.uk>
	<20120422221329.GB24109@redhat.com>
	<20120422233454.7cdd0f35@pyramind.ukuu.org.uk>
	<20120422230156.GA25181@redhat.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Anyway, your no compromises approach is admirable but it doesn't erase
> the fact that all proprietary Linux drivers use EXPORT_SYMBOL code.

People still steal from shops. It doesn't mean we should abolish the idea
of theft.

> So what you're really saying is no proprietary drivers are allowed to be
> loaded into a Linux kernel.

The GPL defines the boundary. Whether it is possible for a work to be
non-derivative and a kernel module is a matter for the lawyers to debate.
If it is derivative however I don't think there is quite so much doubt.

Linus wrote the following

|>"On Wed, 3 Dec 2003, Kendall Bennett wrote:
|>
|> I have heard many people reference the fact that the although the Linux
|> Kernel is under the GNU GPL license, that the code is licensed with an
|> exception clause that says binary loadable modules do not have to be
|> under the GPL.
|
|Nope. No such exception exists.
|
|There's a clarification that user-space programs that use the standard
|system call interfaces aren't considered derived works, but even that
|isn't an "exception" - it's just a statement of a border of what is
|clearly considered a "derived work". User programs are _clearly_ not
|derived works of the kernel, and as such whatever the kernel license is
|just doesn't matter.
|
|And in fact, when it comes to modules, the GPL issue is exactly the same.
|The kernel _is_ GPL. No ifs, buts and maybe's about it. As a result,
|anything that is a derived work has to be GPL'd. It's that simple.

(and then goes on to discuss further his own personal opinion)

http://kerneltrap.org/node/1735

But you still misunderstand the fundamental problem, and this really
needs to be discussed with Red Hat legal.

Alan
