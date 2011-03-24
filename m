Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250Ab1CXHIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 03:08:40 -0400
Received: from vms173007pub.verizon.net ([206.46.173.7]:61136 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933055Ab1CXHIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 03:08:39 -0400
From: Len Brown <lenb@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: [PATCH 0/5] x86 idle cruft removal
Date: Thu, 24 Mar 2011 03:08:23 -0400
Message-id: <1300950508-22746-1-git-send-email-lenb@kernel.org>
X-Mailer: git-send-email 1.7.4.1.343.ga91df
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bit of Spring-cleaning in the x86 idle code,
so that we don't need to maintain this baggage
through upcoming cpuidle changes.

cheers,
-Len

