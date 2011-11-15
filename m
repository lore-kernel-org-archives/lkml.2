Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab1KOERv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 23:17:51 -0500
Received: from hapkido.dreamhost.com ([66.33.216.122]:35997 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab1KOERu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 23:17:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=jidanni.org; h=from:to:subject
	:date:message-id:mime-version:content-type; q=dns; s=jidanni.org
	; b=MQC1FSoaqGzduMIN4lxt+sdE8DG658+qo7rdNECUzjNUaf9I/xCpOiEqsW2e
	U4gZs1X1H2iycbt2XEHVeBhAHdxpnX1UiyNlI4SLAf+57fhoc3Ge0QbrXJ33aV4d
	2bkyOravb2S5EZlYH/2+bthB2Eupsh/wod2v27VS9j6k+as=
From: jidanni@jidanni.org
To: linux-kernel@vger.kernel.org
Subject: Documentation/input/input.txt.gz has a bug
Date: Tue, 15 Nov 2011 09:24:28 +0800
Message-ID: <8762im2n5f.fsf@jidanni.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/usr/share/doc/linux-doc-3.0.0/Documentation/input/input.txt.gz
Has an error at "(c, 13, 32)" or needs an explanation added:

  Doing a cat /dev/input/mouse0 (c, 13, 32) will verify that a mouse
is also emulated, characters should appear if you move it.

Bye.
