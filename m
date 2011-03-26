Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab1CZPy5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 11:54:57 -0400
Received: from tex.lwn.net ([70.33.254.29]:57933 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217Ab1CZPy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 11:54:56 -0400
Date: Sat, 26 Mar 2011 09:54:54 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PULL] Documentation updates
Message-ID: <20110326095454.0a35eb8b@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Linus,

I have a couple of documentation patches at:

  git://git.lwn.net/linux-2.6.git docs-next

They are an update of the development process document to current times
and a fix for a wrong function name in the dynamic debugging doc.

Thanks,

jon

Jonathan Corbet (2):
      docs: fix dev_debug() braino in dynamic-debug-howto.txt
      docs: update the development process document

 Documentation/development-process/1.Intro          |   18 +-
 Documentation/development-process/2.Process        |  177 ++++++++++----------
 Documentation/development-process/3.Early-stage    |   31 +++-
 Documentation/development-process/4.Coding         |   21 ++-
 Documentation/development-process/5.Posting        |   28 ++--
 Documentation/development-process/6.Followthrough  |   16 +-
 Documentation/development-process/7.AdvancedTopics |    4 +-
 Documentation/dynamic-debug-howto.txt              |    4 +-
 8 files changed, 169 insertions(+), 130 deletions(-)
