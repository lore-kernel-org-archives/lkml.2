Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab2KZGgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 01:36:39 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:57732 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab2KZGgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 01:36:38 -0500
MIME-Version: 1.0
Date: Mon, 26 Nov 2012 14:36:37 +0800
Message-ID: <CAEk7JKYs2RiNX9vzrNr1eA6-CPMogVvgpO3j8VRhv6dFyPWhNg@mail.gmail.com>
Subject: Questions about function detect_intel_iommu(void)
From: "Li, Zhen-Hua" <lizhenhua.dev@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
     I am debugging a bug about iommu recently and got a question
about the function detect_intel_opmmu,  Could anybody kindly help me?

     In dmar.c, this function :
                void __init detect_intel_iommu(void)
     In 2.6.32 and redhat enterprise kernel 2.6.18, it is called by
x86_64 system . But in kernel 3.5.2, it is only needed on IA64 system.

    And my question is: is this function really needed for x86_64 and
i386 in 2.6.32?


Thanks and Regards.

Li, Zhen-Hua
