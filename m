Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab0D1VwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 17:52:21 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:41799 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186Ab0D1VwS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 17:52:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=VjE8IoYHn4l0xNJXQyoTn7diGGsA9yblgF45iGlSU5x1jJVLYWSvTetLMp1B915xQn
         VkCtzlIsVucmSqqEgPOA9MSdJvWWhr+/20WnsVuCAft/GA+/heB1Ot4NpBgPo1afc/Y1
         12lxAGRbfpm7shUYzrKhJcCorR4QK9UPvUmqI=
From: Pedro Francisco <pedrogfrancisco@gmail.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: ath5k misbehaving affecting other kernel parts unrelated?
Date: Wed, 28 Apr 2010 22:52:07 +0100
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: me@bobcopeland.com, "John W. Linville" <linville@tuxdriver.com>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       mickflemm@gmail.com
References: <201004230806.13628.pedrogfrancisco@gmail.com> <q2p19f34abd1004240509r63449b41l379bc14f5c6eaeae@mail.gmail.com> <201004241828.37489.pedrogfrancisco@gmail.com>
In-Reply-To: <201004241828.37489.pedrogfrancisco@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004282252.07424.pedrogfrancisco@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A Sábado, 24 de Abril de 2010 18:28:36 Pedro Francisco escreveu:
-snip 
> I get an error booting as if I'd forgotten to compile my disk's controller;
-snip

I am now able to compile my own kernels using `make all deb-pkg' on the 
vanilla source and additional hocus-pocus to create the initramfs, after 
having finally given up on using the Debian way (make-kpkg).


A Sexta, 23 de Abril de 2010 17:37:03 me@bobcopeland.com escreveu:
-snip
> Advice for debugging: turn on slub/slab debug options, and possibly
> kmemcheck.  kmemcheck was very helpful for me last time I had such
> a corruption issue.

I can't seem to find the "kmemcheck: trap use of uninitialized memory" option 
in make menuconfig, section Kernel Hacking, though a search shows it should be 
there.

Will it be useful if I do such tests now that I've opened a bug report with 
data from slab_debug?
If so, how can I enable such feature?

P.S.: considering I'm just planning on using the kernel for the tests, I don't 
bother enabling options which hurt interactivity, as long as a terminal works 
well.

Thanks again,
-- 
Pedro
