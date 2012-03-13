Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898Ab2CME4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 00:56:35 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:54213 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757185Ab2CME4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 00:56:32 -0400
Date: Mon, 12 Mar 2012 23:56:14 -0500
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [git pull]
Message-ID: <20120312235614.1f22c90b@jbarnes-x220>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 12.43.225.40 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit
4f262acfde22b63498b5e4f165e53d3bb4e96400:

  Merge branch 'fixes' of git://git.linaro.org/people/rmk/linux-arm (2012-03-07 08:33:03 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci for-linus

A single fix for a regression that affects some people who try to
disable ASPM for whatever reason.

Matthew Garrett (1):
      PCI: ignore pre-1.1 ASPM quirking when ASPM is disabled

 drivers/pci/pcie/aspm.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)
