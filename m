Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab2GLCOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 22:14:38 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58806 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab2GLCOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 22:14:37 -0400
MIME-Version: 1.0
Date: Thu, 12 Jul 2012 10:14:35 +0800
Message-ID: <CAK2TD5ygowdy9t1TpfxAPbpvNQfMnMB-3Zp8TKMsTYtBZdGW=Q@mail.gmail.com>
Subject: ARM: why smp_mb() is not needed in the "__mutex_fastpath_lock" and
 "__mutex_fastpath_unlock" functions
From: shan kang <kangshan0910@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
   I wonder why smp_mb() is not needed in the "__mutex_fastpath_lock"
and "__mutex_fastpath_unlock" functions which are located in the
"arch/arm/include/asm/mutex.h"?
   I think "dmb" instruction is necessary there.
