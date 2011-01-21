Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab1AUGmF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 01:42:05 -0500
Received: from ns2.cypress.com ([157.95.67.5]:61749 "EHLO aliases"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753509Ab1AUGmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 01:42:02 -0500
From: "Sutharshan Ramamoorthy / Prod" <srmt@cypress.com>
To: kernelnewbies@nl.linux.org, linux-kernel@vger.kernel.org
Cc: odc@cypress.com
Subject: printk(KERN_x...) vs dev_x()
Date: Thu, 20 Jan 2011 22:38:12 -0800
Message-Id: <20110121062844.M9817@cypress.com>
X-Mailer: Open WebMail 2.50 20050106
X-OriginatingIP: 24.23.136.37 (srmt)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm submitting patches to linux kernel.
I'd like to know, Which is the acceptable practice to print debug messages?

At some places in the code, there is no valid 'dev' pointer to pass to
dev_xx() macro, at such places is it ok to use printk(KERN_XXX...)?

Please let me know correct format of print messages.

Thanks,
Sutharsan.

---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

