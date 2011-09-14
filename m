Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab1INGfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 02:35:12 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35095 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab1INGfK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 02:35:10 -0400
MIME-Version: 1.0
In-Reply-To: <20110914162425.f96e77178dd836da6f825de2@canb.auug.org.au>
References: <20110914162425.f96e77178dd836da6f825de2@canb.auug.org.au>
Date: Wed, 14 Sep 2011 09:35:09 +0300
X-Google-Sender-Auth: nDz3wwG6wjTOQ63cxThawp4g03A
Message-ID: <CAOJsxLEkPbgYCPkknK1ZiPH6RjmAQbLgPnvb=mBVOQrY67m47g@mail.gmail.com>
Subject: Re: linux-next: manual merge of the akpm tree with the slab tree
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 9:24 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Andrew,
>
> Today's linux-next merge of the scsi-post-merge tree got a conflict in
> mm/slab.c between commit fdde6abb3e8d ("slab: use print_hex_dump") from
> the slab tree and commit 0cf5ab251a1a ("When we get corruption reports,
> it's useful to see if the kernel was") from the akpm tree.
>
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Andrew, if you send me the patch to penberg@cs.helsinki.fi, I can fix
up the conflict and carry it in my tree.

                        Pekka
