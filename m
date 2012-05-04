Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab2EDJYK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 05:24:10 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34298 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab2EDJYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 05:24:09 -0400
MIME-Version: 1.0
Date: Fri, 4 May 2012 17:24:08 +0800
Message-ID: <CANudz+uVSGiYUQcaCj95qxc9_shv4YKWmN=X+U3ca+a0CWRiEA@mail.gmail.com>
Subject: Some questions about boot memory
From: loody <miloody@gmail.com>
To: kernelnewbies@kernelnewbies.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all:

 I have some question about the relationship between page table
 creation and bootmemery allocation.
 bootmemory allocation use 1-bit to declare this page is used or not.
 Does that mean when a new page table is creating, it will reference
 the bits of bootmap and add dirty flag on the page of the page table created?

 --
 Thanks a lot
