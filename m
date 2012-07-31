Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab2GaFLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 01:11:46 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51312 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab2GaFLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 01:11:44 -0400
MIME-Version: 1.0
In-Reply-To: <1343690279.8073.215.camel@ul30vt>
References: <20120725142254.12800.61860.stgit@bling.home> <20120727053206.GC11870@drongo>
 <1343690279.8073.215.camel@ul30vt>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 30 Jul 2012 22:11:20 -0700
X-Google-Sender-Auth: Cwd1fJOmR2MnQQSlBoTByh1Aobg
Message-ID: <CA+55aFzTzO-jzHNYSW6Hb5_kmP6aYCWH_hbAauLUn9rf9iLg_w@mail.gmail.com>
Subject: Re: [GIT PULL (PATCH 0/4)] VFIO driver for v3.6
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>, benh@kernel.crashing.org, aik@ozlabs.ru,
        david@gibson.dropbear.id.au, gregkh@linuxfoundation.org,
        joerg.roedel@amd.com, dwmw2@infradead.org, chrisw@sous-sol.org,
        agraf@suse.de, benve@cisco.com, aafabbri@cisco.com,
        B08248@freescale.com, B07421@freescale.com, avi@redhat.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com, ddutile@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 4:17 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> I'm pretty anxious to find out as well.  Linus, ping, any thoughts on
> including this in 3.6?  Thanks,

I just pulled it, but then I unpulled again when I realized it's not a
signed tag and it's on github.

Please, people. Do tagged releases with proper signatures if you're
not using kernel.org or other controlled servers. In fact, I prefer
signed tags even if you *do* use kernel.org etc.

             Linus
