Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab1EDXzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 19:55:55 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:64683 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647Ab1EDXzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 19:55:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vy/g4SefqSUM0ulHp4xf5bQgMNsmYljb+iMHw6pXEy1TtwvtdmFqApsiqpyd1jhcJc
         ZKNoQQ6+fUQctaMJb+OW1V8A8h00QRj2Kpaeq6yzk6OEEr7jodpo84DzvWLROgjix09b
         NtdTsZCINkpdkNFh2/8Y6tmY1UzA2+0LWf/qY=
From: Wanlong Gao <wanlong.gao@gmail.com>
To: gregkh@suse.de, rdunlap@xenotime.net
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH-v6 0/2] KernelDoc:Move the driver model structure to the kerneldoc
Date: Thu,  5 May 2011 07:55:35 +0800
Message-Id: <1304553337-2485-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>


Hi Greg:

I think I did the right work as you said . Resend patch-v6 for you to apply
them together.

1/2:Add the structures to the kerneldoc by add the comments to the device.h
2/2:Remove the structures from the driver-model docs.

Did I?

Thanks

Best regards

Wanlong Gao
