Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab2BKNAY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 08:00:24 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:37635 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755111Ab2BKNAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 08:00:23 -0500
MIME-Version: 1.0
Date: Sat, 11 Feb 2012 21:00:22 +0800
Message-ID: <CACXhFTsSo5e4WKsYMgLArvLAbwVGWeZJoF=9ga49u8hQHFrPyQ@mail.gmail.com>
Subject: strange errors during the transplant
From: Hua Li <privatestuffs@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

I am trying to transplant the linux kernel.

I downloaded the linux kernel and got the cross compiler from
ftp://ftp.arm.linux.org.uk/pub/armlinux,
then I specified the ARCH and CROSS_COMPILE in the Makefile, then I
executed the following:

make xconfig
make clean
make

I encountered two errors here:
cc1: invalid option 'abi=apcs-gnu'
cc1: unrecognized option '-fstack-protector'
make[1]: *** [kernel/bounds.s] Error 1
make: *** [prepare 0]Error 2

How can I fix these two errors? Thanks a lot!
