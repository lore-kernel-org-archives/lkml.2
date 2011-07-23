Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587Ab1GWDqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 23:46:15 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:44507 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab1GWDqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 23:46:04 -0400
Message-ID: <4E2A43F5.1020209@landley.net>
Date: Fri, 22 Jul 2011 22:45:57 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Here's a unified kernel git repo covering 0.0.1 to the present.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ever done a "git annotate" that stops at 2.6.12-rc2, and wanted to see 
the full history?  Here's an repository that goes all the way back to
0.0.1 (through bitkeeper and all those old tarballs), which otherwise
works as normal (git pull updates it from Linus's tree, you can commit
to it and branch from it, etc)

Here's the tarball:

  http://www.kernel.org/pub/linux/kernel/people/landley/linux-fullhist.tar.bz2

To install it:

  1) Download, extract, cd into the directory.
  2) git checkout -f
  3) git pull

Then use as normal.

This is based on the work of http://padator.org/linux.php with some
trivial cleanups.

Rob
