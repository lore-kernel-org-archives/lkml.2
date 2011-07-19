Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab1GSL7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 07:59:20 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:64626 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab1GSL7S convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Tue, 19 Jul 2011 07:59:18 -0400
Message-Id: <4E258DB2020000780004E3D4@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 19 Jul 2011 12:59:14 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3, resend] x86: rw lock and semaphore consolidation
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

