Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab0GVTJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 15:09:19 -0400
Received: from mail.candelatech.com ([208.74.158.172]:34397 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab0GVTJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 15:09:17 -0400
From: Ben Greear <greearb@candelatech.com>
To: linux-kernel@vger.kernel.org
Subject: [net 0/2]  Clean up netfilter cache on xmit-to-self.
Date: Thu, 22 Jul 2010 12:09:14 -0700
Message-Id: <1279825756-11568-1-git-send-email-greearb@candelatech.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are against 2.6.34.1.  The first one may be
worth submitting to stable.  The second one is less critical
and should probably just go in the development tree.

