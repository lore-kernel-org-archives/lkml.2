Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab2DXNln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 09:41:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53851 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699Ab2DXNlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 09:41:40 -0400
From: Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>
To: <grant.likely@secretlab.ca>, <linus.walleij@stericsson.com>
CC: <linux-kernel@vger.kernel.org>,
        Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>
Subject: [PATCH] inline, GPIO: Add support for TI TCA6424
Date: Tue, 24 Apr 2012 15:41:02 +0200
X-Mailer: git-send-email 1.7.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-KSE-AntiSpam-Interceptor-Info: protection disabled
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean
Message-Id: <0MTePA-1Sn6qg3jeK-00QVLP@mrelayeu.kundenserver.de>
X-Provags-ID: V02:K0:9LMmVPkWzy2ln3ajNqtsHF1wEDkPzqzo0lvbE0c9hBO
 ZU1GZ3xdMJxQuHugf4HGdVyCbrVPU1EJcj2fKYWDblzxsGPN9e
 s+vl1b8yW2Q1+CKaMBpcUnqpqXozdk0aSWojBZI+O6o2CHP6CW
 R9SNnow2zurymFT+wXgUmFYIXZehZ8QKa2AOlcjh4uOyeGIJhn
 vWmabQwzErUAIERGAFAuh8ADRKXhdxpj6zSh8VGGRh7fUwqNRP
 4zaWEDHXJbtI6JQIzZu6JVYugdPQ1FYwdQu2DhGW32q7ujuxCO
 pmOI50g+yiP+YsdTaQDpT+KcLUh/rnYA3K/3JM+aI4h6qGNGD1
 dHLYh1A/sqrupZm4HfzAFU3HVaG8pWjL5aS9uNFlNoh2dvaZvT
 cyX6d0ddSGe/A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends the PCA953x driver to support TI's TCA6424.
It is based on code by Michele Bevilacqua. Please review.

Signed-off-by: Andreas Schallenberg<Andreas.Schallenberg@3alitytechnica.com>

