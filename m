Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965751Ab0GPOpQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 10:45:16 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:60965 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965729Ab0GPOpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 10:45:14 -0400
Message-ID: <1279291506.4c407072ac83e@imp.free.fr>
Date: Fri, 16 Jul 2010 16:45:06 +0200
From: jeanphilippegerard@free.fr
To: linux-kernel@vger.kernel.org
Subject: Possibility of fixing ASUS M51SE laptops graphic BIOS bug in current Lucid Lynx Kernel ?
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.8
X-Originating-IP: 195.167.200.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Possibility of fixing ASUS M51SE laptops graphic BIOS bug
in current Lucid Lynx Kernel ?

ASUS M51SE laptops graphic BIOS
assigns a wrong prefetchable mmio window to bridge 00:01.0  (etc.)

A patch - asus-m51se-pci-quirk -
to be inserted in
. arch/X86/pci/fixup.c
. arch/ia64/pci/fixup.c
has been written in spring 2009.

It works.

It has not yet been incorporated in current kernel

Is it possible to backport this corrective
in Lucid Lynx's kernel ?

Thank's in advance.

Jean-Philippe in Paris (France)
(owner of a ASUS M51SE)

REFERENCE
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/316079

