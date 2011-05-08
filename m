Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab1EHOh4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 10:37:56 -0400
Received: from netrider.rowland.org ([192.131.102.5]:53590 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752310Ab1EHOhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 10:37:54 -0400
Date: Sun, 8 May 2011 10:37:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg Dietsche <gregory.dietsche@cuw.edu>
cc: gregkh@suse.de, <mfuzzey@gmail.com>, <tom.leiming@gmail.com>,
        <ak@linux.intel.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: fix warning in usbtest module
In-Reply-To: <1304825264-26853-1-git-send-email-gregory.dietsche@cuw.edu>
Message-ID: <Pine.LNX.4.44L0.1105081033140.30441-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 May 2011, Greg Dietsche wrote:

> On amd64 unsigned is not as wide as pointer and this causes
> a compiler warning. Switching to uintptr_t fixes the problem
> in an arch independent manner.

People tend to prefer to see non-typedef'ed type names, whenever 
possible.  In this case, it would be enough to change the type to 
unsigned long.

Lots of code throughout the kernel stores pointer values in unsigned 
long variables.  I've never heard any recommendation for using 
uintptr_t instead.

Alan Stern

