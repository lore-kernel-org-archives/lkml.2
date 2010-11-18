Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab0KRJti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 04:49:38 -0500
Received: from mail.sysgo.com ([195.145.229.155]:43436 "EHLO mail.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756305Ab0KRJth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 04:49:37 -0500
Date: Thu, 18 Nov 2010 10:50:15 +0100
From: Pavel Machek <pma@sysgo.com>
To: kernel list <linux-kernel@vger.kernel.org>, horms@verge.net.au,
        vgoyal@redhat.com, akpm@linux-foundation.org
Cc: randy.dunlap@oracle.com
Subject: kexec documentation missing, bad links in kdump.txt
Message-ID: <20101118095015.GA12071@pma.sysgo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Where can one get kexec documentation?

(In particular, we are trying to get it to boot on ARM board, and
wonder if something like CONFIG_RELOCATABLE_KERNEL is needed.)

Unfortunately, only pieces mentioning kexec are kdump pieces
(Documentation/kdump/kdump.txt), and links there, such as

http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/kexec-tools.tar.gz

http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/README.html

http://www.kernel.org/git/?p=linux/kernel/git/horms/kexec-tools.git

are no longer valid :-(.
								Pavel
