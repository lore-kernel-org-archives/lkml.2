Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023Ab1D3RUi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 13:20:38 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38423 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab1D3RUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 13:20:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject;
        b=DkUS7qQuoJhKOcQvSoIV8oaAsEzc/2T72nHwwiSGZIcWwBNSLteOpcHlMS7srjY/9M
         oruEp9QeqIw4misBBGDTNhVM9pW4MT2jdG8ELS0k3BK48KcIxqjGyFTOr1/PmK/HDB2B
         6K1MBzNy6pmWh+5a+xZL/gMzCdCnjM9JosUyk=
Message-Id: <20110430171459.685415696@openvz.org>
User-Agent: quilt/0.47-1
Date: Sat, 30 Apr 2011 21:14:59 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [patch 0/2] x2apic optimization, round 4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Ingo, here is an updated series of two patches for
x2apic cluster mode ipi optimization. Please take a
look.

  The only concern which was unresolved is a messy bit
in default_setup_apic_routing(), so we've added a FIXME
there and clean it up as only time permits. Actually I
have a plan to merge probe_32/64.c into single file (and
even started working on this task) but not yes succeed.

  Anyway I think patches should be in a good shape now and
probably we could merge them to not lose?

  Comments are welcome.

Thanks,
  Cyrill
