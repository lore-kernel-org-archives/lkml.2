Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab2HMPZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 11:25:27 -0400
Received: from mail.vyatta.com ([76.74.103.46]:35361 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab2HMPZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 11:25:25 -0400
Date: Mon, 13 Aug 2012 08:25:15 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] iproute2 3.5.1
Message-ID: <20120813082515.1582bfbb@nehalam.linuxnetplumber.net>
In-Reply-To: <20120801160550.344a66b1@nehalam.linuxnetplumber.net>
References: <20120801160550.344a66b1@nehalam.linuxnetplumber.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm re-releasing the iproute2 tools for 3.5.0 kernel.

There were a couple of bugs (one serious) in the 3.5.0 version.

Source:
  http://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-3.5.1.tar.gz

The iproute2 3.5.1 git tree can be found at:
  git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/iproute2.git iproute-3.5.1


-----------

Mike Frysinger (1):
      Fix regression with 'ip address show'

Stephen Hemminger (1):
      v3.5.1

Xose Vazquez Perez (1):
      Fix Makefile's

