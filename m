Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab0ERAUh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 20:20:37 -0400
Received: from tex.lwn.net ([70.33.254.29]:45083 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542Ab0ERAUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 20:20:36 -0400
Date: Mon, 17 May 2010 18:20:34 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PULL] Documentation
Message-ID: <20100517182034.014b031e@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Linus,

I have one change (a document for the padata layer) in my docs tree:

  git://git.lwn.net/linux-2.6.git docs-next

Jonathan Corbet (1):
      Add a document describing the padata interface

 Documentation/00-INDEX   |    2 +
 Documentation/padata.txt |  107 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 109 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/padata.txt

Guaranteed 100% regression-free.

Thanks,

jon
