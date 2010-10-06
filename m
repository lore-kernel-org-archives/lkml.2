Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530Ab0JFBGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 21:06:19 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35223 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758299Ab0JFBF7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 21:05:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:content-type:content-transfer-encoding:subject:date:message-id
         :cc:to:mime-version:x-mailer;
        b=iH7firNvCuqBxxvchZ6dxMU+m5W+Ap0rSimIKq2BfLQnfL1qRZ53BFti6wXefqKF5w
         U5D+fvCmzUQkyQ4vbeX/wD01qN89+KRlN+7pzAvILAykRchbLLDHegQsM1IRF/aokXEg
         8KGrbQxN601vpiDBDb3qKKQh8qzBG1wZHXz4s=
From: bhs <haishan.bai@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: Why not distribute timer handlers on CPUs on SMP
Date: Wed, 6 Oct 2010 09:05:52 +0800
Message-Id: <2B624B3F-9338-4336-B4F6-D61B476DA255@gmail.com>
Cc: haishan.bai@gmail.com
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1078)
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am just curious about why handle the timer functions on a CPU serially but not distribute them over CPUs
even on a SMP system?

The timer wheel handler function __run_timers() serializes the timer functions on a CPU,
is there any design consideration that handling timers on a CPU is more reasonable than distribute them
over CPUs?


Best regards
Shan Hai