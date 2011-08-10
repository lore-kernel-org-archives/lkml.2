Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab1HJSd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 14:33:27 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:48575 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590Ab1HJSdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 14:33:25 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1108101418540.16220@x980>
References: <cover.1312893572.git.luto@mit.edu> <20110809135050.79eed316@lxorguk.ukuu.org.uk>
 <CAObL_7G5j-8dmQDc2Q+matB8nHk7421CWnBHqQs9-T2fjVecng@mail.gmail.com> <alpine.LFD.2.02.1108101418540.16220@x980>
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 10 Aug 2011 14:33:05 -0400
X-Google-Sender-Auth: YsPqEMFNUY7AcXkOFDFZqNqkzVY
Message-ID: <CAObL_7ECQwEerFcs+y15NaryLa7QgXSnxktctfnfYttG2bquoA@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] Forcibly enable some MISC_ENABLE features on Intel
To: Len Brown <lenb@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, linux-acpi@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 2:21 PM, Len Brown <lenb@kernel.org> wrote:
> Andrew,
>
> FWIW,
> Intel's internal bug database claims this issue on your board
> is fixed in the next BIOS update.

Yay for fixes.  But the FW_WARN might get these things noticed and fixed sooner.

Also, the fast string issue is present in Lenovo machines, too, so
Intel can't fix them all.

--Andy
