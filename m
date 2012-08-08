Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863Ab2HHHqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 03:46:44 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:38866
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751959Ab2HHHqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 03:46:43 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh2a8h668h839h944hd25hf0ah107ah)
Date: Wed, 8 Aug 2012 15:46:23 +0800
From: Richard Zhao <richard.zhao@freescale.com>
To: <viro@zeniv.linux.org.uk>
CC: <dirk.behme@de.bosch.com>, <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>
Subject: how to vm_munmap memory range for other processes?
Message-ID: <20120808074622.GB3824@b20223-02.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

I saw two commits from you in git tree:
17d1587 unexport do_munmap()
bfce281 kill mm argument of vm_munmap()

They remove the mm arguments, so it look like impossible to unmap
memory of other processes except current.

I have a kernel module that needs to unmap memory for certain pid. Do
you have any idea how to do it?

Thanks
Richard

