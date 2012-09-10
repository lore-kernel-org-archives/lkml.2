Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721Ab2IJMhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 08:37:12 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:37897 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867Ab2IJMhJ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Mon, 10 Sep 2012 08:37:09 -0400
Message-Id: <504DFB10020000780009A321@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 10 Sep 2012 13:37:04 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] x86: xor-block handling adjustments
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1: unify SSE-base xor-block routines
2: improve XMM register spill/fill
3: add alternative SSE implementation only prefetching once per 64-byte line
4: make virtualization friendly

Signed-off-by: Jan Beulich <jbeulich@suse.com>

