Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab0KBHt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 03:49:28 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38998 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab0KBHtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 03:49:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=M+haw/bQlPX0czDSiL8KB4HAWle+eF++aonTZ7TOXHitXcLzGMpZgAYb70V3ycbrBc
         N5+08zXI0RXUwvqf5TCzDejmdshTpQhfPZmY5isv2PNnKqUdkm3TlRyQAzoAdui1jtG8
         0iQwce4TGywCmi8KRCtckjBxghk7SgcGre3SE=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Tue, 2 Nov 2010 08:49:20 +0100
Message-ID: <AANLkTinPTrc6FpBRTZbDcsOdwpRUayQuE+2K8U8yPorz@mail.gmail.com>
Subject: Where is the SLAM (a mutable slab allocator) development happening?
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Cc: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while looking through the program of LPC, I have seen a proposal for a
talk called "SLAM: a mutable slab allocator" [1].

As there was no reference given to the code-base, I went searching on
the Wild Wild Web and found a thread called "[UnifiedV4 00/16] The
Unified slab allocator (V4)" posted to LKML.
It looks to me that these patches went to Pekka's slab/for-next GIT-branch [2].
I am not sure if this is "SLAM".

[1] says:
"I have worked as a kernel developer at Google for 3 1/2 years...",
not sure if David Rientjes email-address at Google is still valid,
thus I am sending my request to slab ML and Mainrtainers.

Can someone say where to get more informations on SLAM?
The commits in slab/for-next look also interesting to me, can someone
give an overview what can be expected in 2.6.38?
(I would give linux-next a try).

Thanks in advance for answering my questions.

Kind Regards,
- Sedat -

[1] http://www.linuxplumbersconf.org/2010/ocw/proposals/405
[2] http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=shortlog;h=refs/heads/for-next
