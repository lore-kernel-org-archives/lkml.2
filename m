Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762922Ab2KBOQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 10:16:53 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:51378 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762889Ab2KBOQu convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Fri, 2 Nov 2012 10:16:50 -0400
Message-Id: <5093E40902000078000A6147@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 02 Nov 2012 14:17:29 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3, v2] x86: xor-block handling adjustments
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2 of this series is merely updated on top of the changes between
3.6 and 3.7-rc (which includes the dropping of what previously was
the second patch in a four patch series).

1: unify SSE-base xor-block routines
2: add alternative SSE implementation only prefetching once per 64-byte line
3: make virtualization friendly

Signed-off-by: Jan Beulich <jbeulich@suse.com>

