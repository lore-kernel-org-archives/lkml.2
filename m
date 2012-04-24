Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab2DXRuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 13:50:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37336 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755819Ab2DXRuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 13:50:03 -0400
Date: Tue, 24 Apr 2012 13:50:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kernel development list <linux-kernel@vger.kernel.org>
Subject: 64-bit modulus operation in a 32-bit kernel
Message-ID: <Pine.LNX.4.44L0.1204241347490.1511-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I need to compute the remainder when a 64-bit quantity is divided by a 
small value (126 in this case).  The % operator doesn't work in an 
x86/32 kernel.  What's the Right Way to do it?

Alan Stern

