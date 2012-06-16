Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab2FPUTU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 16:19:20 -0400
Received: from netrider.rowland.org ([192.131.102.5]:50831 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755995Ab2FPUTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 16:19:19 -0400
Date: Sat, 16 Jun 2012 16:19:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Bojan Smojver <bojan@rexursive.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Borislav Petkov <bp@alien8.de>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
In-Reply-To: <90304ca8-31ef-4919-bf9d-e0498b0de87b@email.android.com>
Message-ID: <Pine.LNX.4.44L0.1206161617080.819-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jun 2012, Bojan Smojver wrote:

> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> >Hmm.  Is there any fix, though?
> 
> How do we tell printk() to not dump stuff into dmesg?

You can't; that's what printk() does, by definition.  If you don't want 
stuff to go into the dmesg buffer then don't call printk().

>  Or, how do we
> otherwise just print to the console?

That's a better question.  Unfortunately, I don't know the answer.

Alan Stern

