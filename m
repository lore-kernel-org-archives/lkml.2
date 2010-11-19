Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab0KSLFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 06:05:09 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47244 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab0KSLFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 06:05:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=erki1Z1FMFhZHjQxiQD6RN94/XSjx0VThWy3HEW1h3aodgVsf+uoCuWxCCKe38ypo9
         4NgZbkgLsknJ5GE33dyhV2lyxgoYZXK1SLwv8K0iJ5BI1Yn52kt/Svde8G+ZPrX0SRvB
         74Gzxz0sbI2OJGN+Nvvt1piB3t49caaQQVqFc=
MIME-Version: 1.0
Date: Fri, 19 Nov 2010 19:05:07 +0800
Message-ID: <AANLkTi=1cF5o2OAXBxyTjQfp=ir+=k4X7d7MNRjO-91G@mail.gmail.com>
Subject: x86 PAE memory mode
From: tingwei liu <tingw.liu@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If I open PAE mode on X86_32 platform,the efficiency of mmu will be lower?
Another question:
Why the kernel  doesn't  use  the flag "GFP_HIGHMEM"  to get memory
while it can't get memory by using flag "GFP_KERNEL",on the contrary,
the kernel get memory from killing process ?

Your response is pleasure.
