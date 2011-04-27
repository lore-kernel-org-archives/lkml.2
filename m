Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329Ab1D0PWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:22:38 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:35996 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758882Ab1D0PWh convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Wed, 27 Apr 2011 11:22:37 -0400
Message-Id: <4DB85127020000780003E69F@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 27 Apr 2011 16:23:51 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] x86: rw lock and semaphore consolidation
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to unify 32- and 64-bit assembly implementations and to eliminate
a (mostly theoretical) scalability problem in the rwlock logic.

1: unify rwlock assembly implementation
2: unify rwsem assembly implementation
3: fix write lock scalability 64-bit issue

Signed-off-by: Jan Beulich <jbeulich@novell.com>

