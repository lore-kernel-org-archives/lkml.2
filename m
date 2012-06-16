Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881Ab2FPUJu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 16:09:50 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:47085 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140Ab2FPUJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 16:09:49 -0400
References: <Pine.LNX.4.44L0.1205132212070.5628-100000@netrider.rowland.org> <201206161559.30267.rjw@sisk.pl> <20120616173952.GA20623@liondog.tnic> <201206162117.08877.rjw@sisk.pl>
User-Agent: K-9 Mail for Android
In-Reply-To: <201206162117.08877.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
From: Bojan Smojver <bojan@rexursive.com>
Date: Sun, 17 Jun 2012 06:09:42 +1000
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Borislav Petkov <bp@alien8.de>
CC: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Message-ID: <90304ca8-31ef-4919-bf9d-e0498b0de87b@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

>Hmm.  Is there any fix, though?

How do we tell printk() to not dump stuff into dmesg? Or, how do we otherwise just print to the console?

The rest should be trivial...

-- 
Bojan
