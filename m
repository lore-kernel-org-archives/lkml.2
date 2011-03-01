Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026Ab1CATSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:18:22 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:45441 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756904Ab1CATST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:18:19 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Ondrej Zajicek <santiago@crfreenet.org>
Subject: [PATCH 0/5] s3fb: various changes
Date: Tue, 1 Mar 2011 20:17:59 +0100
User-Agent: KMail/1.9.10
Cc: linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201103012018.01607.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds new hardware support, fixes some display problems and also
improves performance of s3fb driver.

Everything was tested on various Trio32, Trio64V+, Trio64V2/DX, Virge, 
Virge/DX, Trio3D and Trio3D/2X cards.

It assumes that David Miller's "Make SVGA oriented FBs work on multi-domain 
PCI" patch set is applied.

Signed-off-by: David S. Miller <davem@davemloft.net>

-- 
Ondrej Zary
