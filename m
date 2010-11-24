Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247Ab0KXH2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 02:28:40 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57344 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab0KXH2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 02:28:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=UMRNlTvVFkt8yE/0Ad0rDxqKL4qIbVDpT+FCNMfpptFB18ee0g6u5r7xwJVHbVWnyA
         3ZoS2FuT2RvUhxTl0ItiQAPbIYnBWf0IIwqRj7e+BZ3ndgIlse8cf1cfiqwTlsI3AvEF
         ph1ms92rSDxxEhUCvvBUpOrgR7v7svY6OQlDg=
MIME-Version: 1.0
Date: Wed, 24 Nov 2010 15:28:37 +0800
Message-ID: <AANLkTimoBdFyQ6GfS2DKiF0wdRox0x7MfM0_keD9Z1D0@mail.gmail.com>
Subject: [question] NR_IRQS in genirq
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm using the latest kernel 2.6.37-rc1. Now I met some issues on genirq.

1. While SPARSE IRQ is enabled, nr_irqs may be larger than NR_IRQS.
But the allocated_irqs bitmap (kernel/irq/irqdesc.c) is restricted in
NR_IRQS. Is it an issue?

2. irqs_resend bitmap of kernel/irq/resend.c is also restricted in
NR_IRQS. Is it an issue, too?

Thanks
Haojian
