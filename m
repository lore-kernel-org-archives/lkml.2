Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933472Ab0JZSEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 14:04:43 -0400
Received: from pecan.exetel.com.au ([220.233.0.17]:45461 "EHLO
	smtp.po.exetel.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933225Ab0JZSEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 14:04:39 -0400
From: "Alex Dubov" <oakad@yahoo.com>
To: "LKML" <linux-kernel@vger.kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
        "Maxim Levitsky" <maximlevitsky@gmail.com>
Subject: memstick: Alternative approach to proposed fixes
Date: Wed, 27 Oct 2010 04:41:07 +1100
Message-Id: <1288114871-805-1-git-send-email-oakad@yahoo.com>
X-Mailer: git-send-email 1.6.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I was not able to convince myself that profound changes proposed by Maxim
are really necessary, I propose to follow a much milder path with this update
round (as I outlined in my previous emails).

In this small patchset, I fix a couple of small omissions as well as introduce
support for "extended command" MSPro transfer method (currently enabled for
JMicron, but I'll clear the TI host for this functionality soon). I expect the
current solution to scale trivially for HG and XC transfer methods (I don't
have the spec for the later yet).

I'm still investigating possible issues with JMicron adapter. As JMicron is
known to follow a rather uneven path with their chip revisions, revision
dependent quirks may need to be introduced in the driver if I'm unable to
confirm Maxim's findings.

