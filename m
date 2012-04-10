Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723Ab2DJNXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 09:23:46 -0400
Received: from m50-132.163.com ([123.125.50.132]:41005 "EHLO m50-132.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762Ab2DJNXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 09:23:45 -0400
From: "Li Wang" <dragonylffly@163.com>
To: "Tyler Hicks" <tyhicks@canonical.com>, <dustin.kirkland@gazzang.com>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <ecryptfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
Subject: [RFC] eCryptfs file system with HMAC verification
Date: Tue, 10 Apr 2012 21:22:24 +0800
Message-ID: <000301cd171c$f8bb4cc0$ea31e640$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac0XHPekaJInBsRUSDyrEce3yp35lQ==
Content-Language: zh-cn
X-CM-TRANSID: DNGowEAp43gTNIRPprCeCA--.933S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUSRwZUUUUU
X-CM-SenderInfo: 5gudw0hq1owwlo16il2tof0z/1tbiWxSM509opfh1zAAAsn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  we have implemented a prototype, which equips eCryptfs with HMAC verification,
based on the kernel crypto API. This enables eCryptfs to detect unauthorized (cipher) 
data modification and unexpected data corruption. And the preliminary experiments 
demonstrate the decrease in throughput is modest. As a file system highlighting security,
we think it should be useful.
  Any comments/suggestions are welcome.

Cheers,
Li Wang


