Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab2JAJHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 05:07:18 -0400
Received: from smtp2.infineon.com ([217.10.60.23]:4092 "EHLO
	smtp2.infineon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab2JAJHQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 05:07:16 -0400
X-SBRS: None
From: <Peter.Huewe@infineon.com>
To: <jgunthorpe@obsidianresearch.com>, <linux-kernel@vger.kernel.org>,
        <tpmdd-devel@lists.sourceforge.net>
Subject: RE: [tpmdd-devel] [PATCH] TPM: Let the tpm char device be openable
	multiple times
Thread-Topic: [tpmdd-devel] [PATCH] TPM: Let the tpm char device be openable
	multiple times
Thread-Index: AQHNn2Y1yFzAZfQ3OkOolIErIs1buZekKBhw
Date: Mon, 1 Oct 2012 09:07:11 +0000
Message-ID: <74A44E99E3274B4CB570415926B37D440EAA7F@MUCSE501.eu.infineon.com>
References: <20120930233345.GJ30637@obsidianresearch.com>
In-Reply-To: <20120930233345.GJ30637@obsidianresearch.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.8.248]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

one quick question:
-	TPM_BUFSIZE = 4096,
[...]
+	u8 data_bufferx[2048];

Why do you half the buffer size?

Thanks,
Peter
