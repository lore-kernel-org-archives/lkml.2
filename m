Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab2DDJDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 05:03:14 -0400
Received: from msa102.auone-net.jp ([61.117.18.162]:38930 "EHLO
	msa102.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759Ab2DDJDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 05:03:13 -0400
Date: Wed, 4 Apr 2012 18:03:11 +0900
From: Kusanagi Kouichi <slash@ac.auone-net.jp>
To: netdev@vger.kernel.org
Cc: Pavel Emelyanov <xemul@parallels.com>, linux-kernel@vger.kernel.org
Subject: Commit 8ef874bfc7296fa206eea2ad1e8a426f576bf6f6 has broken ss command
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Message-Id: <20120404090312.1B68C6AC03E@msa102.auone-net.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 8ef874bfc7296fa206eea2ad1e8a426f576bf6f6 ("sock_diag:
Move the sock_ code to net/core/"), ss command from iproute package
doesn't work if INET_DIAG is not enabled.

$ ss
State       Recv-Q Send-Q                                             Local Address:Port                                                 Peer Address:Port
TCPDIAG answers: Operation not supported
