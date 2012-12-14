Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab2LNSnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 13:43:22 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:35005 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757045Ab2LNSnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 13:43:20 -0500
Subject: [RFC][PATCH 0/7] Put "Kernel hacking" Kconfig menu on a diet
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 14 Dec 2012 13:42:00 -0500
Message-Id: <20121214184200.8EC5168B@kernel.stglabs.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121418-4834-0000-0000-00000187607C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think the "Kernel Hacking" menu has gotten a bit out of hand.  It
is over 120 lines long on my system with everything enabled and
options are scattered around it haphazardly.

	http://sr71.net/~dave/linux/kconfig-horror.png

Let's try to introduce some sanity.

