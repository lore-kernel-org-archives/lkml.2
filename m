Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab1EBPFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 11:05:41 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48938 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab1EBPFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 11:05:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QwPfMFWzgNGtZnYcTr1dWzjkA7osRtRPAZ5XyI5tGwfoq4vmIlMHS5tEjGU3QylGUY
         KLZJXHrFGEsmQZxzEn9+ywLXy813L20OPP0wUJMjC4VkMLT+4Tlu3gOUjAOJD2s3usUH
         fIRSOveiSJS/aNchn7LCNKHSEP/0fYH+aERxg=
From: wanlong.gao@gmail.com
To: gregkh@suse.de, rdunlap@xenotime.net, linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org, Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH 0/2] KernelDoc:Move the driver model structure to the kerneldoc
Date: Mon,  2 May 2011 23:04:39 +0800
Message-Id: <1304348681-24950-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>


Hi Greg:

I think I did the right work as you said .

1/2:Add the structures to the kerneldoc by add the comments to the device.h
2/2:Remove the structures from the driver-model docs.

Did I?

Thanks

Best regards

Wanlong Gao
