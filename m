Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934642Ab0HMRp7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 13:45:59 -0400
Received: from ns2.cypress.com ([157.95.67.5]:43262 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761905Ab0HMRp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 13:45:58 -0400
Subject: EXPORT_SYMBOL(fat_get_block)
From: David Cross <david.cross@cypress.com>
Reply-To: david.cross@cypress.com
To: hirofumi@mail.parknet.co.jp
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Content-Type: text/plain
Organization: Cypress
Date: Fri, 13 Aug 2010 10:45:39 -0700
Message-Id: <1281721539.5839.4.camel@odc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Hirofumi,
I would like to export this symbol from the vfat code and add this patch
to the Linux kernel. You are listed as the MAINTAINER for FAT and VFAT.
As such, I need your approval to do it. 
The reason that I need to export this symbol is to allow for file based
DMA in which the file needs to be pre-allocated. The pre-allocated block
addresses are passed to a DMA engine which then directly transfers the
data to non-volatile storage.
Please let me know if you have any objections to exporting this symbol
or if you need additional information from me concerning this change
request. I am happy to answer any questions that you may have about this
in the meantime.
Thanks,
David Cross



---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

