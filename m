Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab0JUFlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 01:41:50 -0400
Received: from elasmtp-galgo.atl.sa.earthlink.net ([209.86.89.61]:53490 "EHLO
	elasmtp-galgo.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753438Ab0JUFlt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 01:41:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=c/YHFmbXMvOQmcW6yp26TwXLkIYUg7+bJmrtlT3PKy6zvz9lt6gvSAzfbFT87hFU;
  h=Received:From:Content-Type:Content-Transfer-Encoding:Subject:Date:Message-Id:To:Mime-Version:X-Mailer:X-ELNK-Trace:X-Originating-IP;
From: Mitchell Erblich <erblichs@earthlink.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: Verification of SYScall changes because of CVE-2009-0029
Date: Wed, 20 Oct 2010 22:40:08 -0700
Message-Id: <7E55CE8C-959B-42B7-B991-4E385D1D6E38@earthlink.net>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1081)
X-Mailer: Apple Mail (2.1081)
X-ELNK-Trace: 074f60c55517ea841aa676d7e74259b7b3291a7d08dfec79e5d154d657ac6f174d8deffc01c54a54350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 4.246.235.72
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

he ABI in the Linux kernel 2.6.28 and earlier on s390, powerpc, sparc64, and mips 64-bit platforms requires that a 32-bit argument in a 64-bit register was properly sign extended when sent from a user-mode application, but cannot verify this, which allows local users to cause a denial of service (crash) or possibly gain privileges via a crafted system call.

Has anyone been able to verify  (a program that exploits this issue) ?

Thanks,
		Please copy me if you respond.		
		Mitchell Erblich