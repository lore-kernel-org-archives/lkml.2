Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab0IHQvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 12:51:51 -0400
Received: from ns2.cypress.com ([157.95.67.5]:40984 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512Ab0IHQvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 12:51:48 -0400
Reply-To: <david.cross@cypress.com>
From: "David Cross" <david.cross@cypress.com>
To: <dhowells@redhat.com>
Cc: <linux-cachefs@redhat.com>, <greg@kroah.com>,
        <linux-kernel@vger.kernel.org>
References: <1283888011.7250.17.camel@odc-laptop> <4313.1283956531@redhat.com>
Subject: RE: [PATCH] Cachefiles, mpage_cleardirty addtition, west bridge related
Date: Wed, 8 Sep 2010 09:51:22 -0700
Organization: Cypress Semiconductor
Message-ID: <9465F8A421744836B35704023ECA8253@stanford.edu>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: ActPYx0sJldoARoJRmyiY0nqvPZdswAEntqQ
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
In-Reply-To: <4313.1283956531@redhat.com>
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: dhowells@redhat.com [mailto:dhowells@redhat.com] 

> David Cross <david.cross@cypress.com> wrote:

> > This patch adds the mpage_cleardirty function to the cachefiles >
implementation in the kernel.

> Ummm...  How is this used by cachefiles?  Nothing in this patch actually >
uses
> mpage_cleardirty().

This is used by the current west bridge driver in the linux-next tree,
marked as BROKEN at the moment. It is used in order to clear dirty pages
from the page cache for a specific file after it has been allocated. This
allows west bridge to transfer data from USB to storage directly without
requiring that the file data path go through the CPU. The easiest way to
think of this is that it allows for direct file based DMA. Please let me
know if you have any additional questions or concerns on this.
Thanks,
David


---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

