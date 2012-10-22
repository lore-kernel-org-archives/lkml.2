Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab2JVUUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 16:20:23 -0400
Received: from fmailer.gwdg.de ([134.76.11.16]:51202 "EHLO fmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756116Ab2JVUUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 16:20:22 -0400
X-Greylist: delayed 2067 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Oct 2012 16:20:22 EDT
Date: Mon, 22 Oct 2012 21:45:02 +0200
From: Julian Wollrath <julian.wollrath@stud.uni-goettingen.de>
To: Julian Wollrath <jwollrath@web.de>
Cc: Patrik Kullman <patrik.kullman@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Major performance regressions in 3.7rc1/2
Message-ID: <20121022214502.0fde3adc@ilfaris>
In-Reply-To: <20121022173315.7b0da762@ilfaris>
References: <CAGPN=9Qx1JAr6CGO-JfoR2ksTJG_CLLZY_oBA_TFMzA_OSfiFg@mail.gmail.com>
	<20121022173315.7b0da762@ilfaris>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Oct 2012 19:45:08.0015 (UTC) FILETIME=[BD85C3F0:01CDB08D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

seems like I found the other bad commit. Everything, which means
v3.7-rc*, works fine again with commit e6c509f85 (mm: use
clear_page_mlock() in page_remove_rmap()) and commit 957f822a0 (mm,
numa: reclaim from all nodes within reclaim distance) revoked.


With best regards,
Julian Wollrath
