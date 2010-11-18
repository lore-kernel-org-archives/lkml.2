Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281Ab0KROgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:36:23 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:40320 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757948Ab0KROgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:36:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Ib2vuaTSBdp6PQfLeTuXPO9hW/M3UhGYlzBkL9jnbB1ILZ0FrSSdq9L5olF99hXM3b
         e+wVNw6Ymf2g5A96oOhptjCx73tmS5jEo40lh0RArPZX7w+dF3LyWvtoTI0yjblcSKbR
         n5yVcMDDwe4yNbuwQGHApMiMlDsTmx83CFjxc=
MIME-Version: 1.0
Date: Thu, 18 Nov 2010 06:36:18 -0800
Message-ID: <AANLkTikToBjx-4go9mAFCcnTQ5X4Su+57ODoY9C5y_7f@mail.gmail.com>
Subject: error while building the kernel Mainline
From: Justin Mattock <justinmattock@gmail.com>
To: linux-net@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hit this yesterday, and havent had time to look at it, to see if its a
simple fix

  MODPOST vmlinux.o
WARNING: modpost: Found 1 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
net/built-in.o: In function `handle_response_icmp':
ip_vs_core.c:(.text+0x2b5c4): undefined reference to `nf_conntrack_untracked'
net/built-in.o: In function `T.925':
ip_vs_core.c:(.text+0x2cbbd): undefined reference to `nf_conntrack_untracked'
net/built-in.o: In function `ip_vs_null_xmit':
(.text+0x310da): undefined reference to `nf_conntrack_untracked'
net/built-in.o: In function `ip_vs_tunnel_xmit':
(.text+0x311e3): undefined reference to `nf_conntrack_untracked'
net/built-in.o: In function `ip_vs_nat_xmit':
(.text+0x3176f): undefined reference to `nf_conntrack_untracked'
net/built-in.o:(.text+0x3199d): more undefined references to
`nf_conntrack_untracked' follow
make: *** [.tmp_vmlinux1] Error 1

has there been anything sent forward for this yet?

-- 
Justin P. Mattock
