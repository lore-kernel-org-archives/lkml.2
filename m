Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab0JRAs6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 20:48:58 -0400
Received: from lo.gmane.org ([80.91.229.12]:48521 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431Ab0JRAs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 20:48:57 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: scripts/extract-ikconfig only works on uncompressed and =?utf-8?b?Q09ORklHX0tFUk5FTF9HWklQ?= kernels
Date: Mon, 18 Oct 2010 00:48:46 +0000 (UTC)
Message-ID: <loom.20101018T024559-314@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 98.117.151.86 (Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100910 Sabayon Firefox/3.6.9)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a kernel that was compiled with LZMA compression (CONFIG_KERNEL_LZMA). I
wish to extract the .config from it without running it, but the script to do so
does not support such kernels. How could I go about fixing this, so that the
script supports other compression modes than just gzip?

