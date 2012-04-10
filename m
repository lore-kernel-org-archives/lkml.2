Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729Ab2DJN1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 09:27:19 -0400
Received: from mail.nudt.edu.cn ([61.187.54.11]:45198 "HELO eyou.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754572Ab2DJN1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 09:27:17 -0400
X-EYOU-SPAMVALUE: 0
X-EYOU-DEALDRC: 
X-EMDG-VER: 2011-01-28
Message-ID: <534063324.06707@eyou.net>
X-EYOUMAIL-SMTPAUTH: liwang@nudt.edu.cn
From: "Li Wang" <liwang@nudt.edu.cn>
To: "Tyler Hicks" <tyhicks@canonical.com>, <dustin.kirkland@gazzang.com>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <ecryptfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
Subject: [RFC] eCryptfs file system with HMAC verification
Date: Tue, 10 Apr 2012 21:26:58 +0800
Message-ID: <000a01cd171d$9e6c23b0$db446b10$@edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac0XHZsCn0zkvpDKRLSSmvn9AaFcPA==
Content-Language: zh-cn
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

