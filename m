Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199Ab2IXUsE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 16:48:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757878Ab2IXUsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 16:48:02 -0400
Date: Mon, 24 Sep 2012 22:49:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <andi@firstfloor.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: smp_alt_once && kernel-parameters.txt
Message-ID: <20120924204948.GA29766@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/alternative.c:

	static int __init bootonly(char *str)
	{
		smp_alt_once = 1;
		return 1;
	}
	__setup("smp-alt-boot", bootonly);
                 ^^^^^^^^^^^^

kernel-parameters.txt:

	smp-alt-once	[X86-32,SMP] On a hotplug CPU system, only
			attempt to substitute SMP alternatives once at boot.

Who should be fixed?

Oleg.

