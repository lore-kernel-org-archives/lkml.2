Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab0CQV61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 17:58:27 -0400
Received: from mail-bw0-f212.google.com ([209.85.218.212]:57530 "EHLO
	mail-bw0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab0CQV60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 17:58:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=BLKcTxBRXmQ8WEAvfzAwXuUSui0aF6JkduXUc4XOdcaezBwxRKqWcuqaUTB9Q1Hm9j
         PXHcIkwjZwHIoc58MIR1x3MDPCvVcP6EDa65H6+2Q1Z7HsVWdWo0yq1MWVFnUNIMpzYd
         pi4AiF5XulB+tXjRb5PeuzOygV/cQOcwm5EIs=
MIME-Version: 1.0
Date: Wed, 17 Mar 2010 22:58:23 +0100
Message-ID: <b637ec0b1003171458t524d168fiab52ce2b3431e3c9@mail.gmail.com>
Subject: Regression - Linux 2.6.34-rc1 - i915 - Render error detected
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, airlied@linux.ie,
       Eric Anholt <eric@anholt.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.
This message returned in 2.6.34-rc1:

[    0.743004] render error detected, EIR: 0x00000010
[    0.743004] page table error
[    0.743004]   PGTBL_ER: 0x00000100
[    0.743004] [drm:i915_handle_error] *ERROR* EIR stuck: 0x00000010, masking
[    0.750116] render error detected, EIR: 0x00000010
[    0.750182] page table error
[    0.750240]   PGTBL_ER: 0x00000100

It has been present since ages, it disappeared in 2.6.33 (the fix went
also to -stable) but it's back again now.

FWIW, the fix was:

 http://lists.freedesktop.org/archives/intel-gfx/2010-February/005803.html

Regards,
Fabio
