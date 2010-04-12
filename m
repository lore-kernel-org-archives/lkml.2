Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab0DLRBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 13:01:38 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49246 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab0DLRBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 13:01:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=hOPAIpJ3/3hMRKVFN/f7muhrz8csd7UpYQYR/vw4ond6+pbU10hCxmc/ZpWChUVqzr
         CnZ0P0AVZQOvJ1GJU6qvmN/5lSDSSbb2hEA6OVsAAxYCfN86uFtztTyhPszC67IY+6FW
         46nMJ0y0kR1f3RNDxu3YfJDg6OgCX3l8w5vmM=
MIME-Version: 1.0
Date: Mon, 12 Apr 2010 12:01:36 -0500
Message-ID: <q2m68f510a71004121001v370509fftc6f4b86c4420b509@mail.gmail.com>
Subject: Accessing peripheral register directly from userspace
From: Krishna Gopal <linuxkrishna@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Would there be any issues for optimization purpose I do a mmap to a
peripheral register to directly access it from userspace ? This is
considering the peripheral already has a Kernel driver through which
you can set the register bit.

Basically I want to avoid the additional context switch on entering
the Kernel to set that one bit in the Peripheral register.

I request you to please share your thoughts.

Best regards,
Krishna
