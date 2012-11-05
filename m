Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab2KEEoJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 23:44:09 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:62584 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab2KEEoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 23:44:08 -0500
MIME-Version: 1.0
In-Reply-To: <CAA_GA1eYHi4zWZwKp5KGi4gP7V8bfnSF=aLKMiN-Wi5JyLaCdw@mail.gmail.com>
References: <508086DA.3010600@oracle.com>
	<5089A05E.7040000@gmail.com>
	<CA+1xoqf2v_jEapwU68BzXyi4abSRmi_=AiaJVHM3dBbHtsBnqQ@mail.gmail.com>
	<CAA_GA1d-rw_vkDF98fcf9E0=h86dsp+83-0_RE5b482juxaGVw@mail.gmail.com>
	<CANN689HXoCMTP4ZRMUNOGAdOBmizKyo6jMqbqAFx8wwPXp+AzQ@mail.gmail.com>
	<CAA_GA1eYHi4zWZwKp5KGi4gP7V8bfnSF=aLKMiN-Wi5JyLaCdw@mail.gmail.com>
Date: Sun, 4 Nov 2012 20:44:07 -0800
Message-ID: <CANN689HfmX8uBa17t38PYv2Ap5d3LPjShq81tbcgET5ZqzjzeQ@mail.gmail.com>
Subject: Re: mm: NULL ptr deref in anon_vma_interval_tree_verify
From: Michel Lespinasse <walken@google.com>
To: Bob Liu <lliubbo@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, hughd@google.com,
        linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 4, 2012 at 8:14 PM, Bob Liu <lliubbo@gmail.com> wrote:
> Hmm, I attached a simple fix patch.

Reviewed-by: Michel Lespinasse <walken@google.com>
(also ran some tests with it, but I could never reproduce the original
issue anyway).

Bob, it would be easier if you had sent the original patch inline
rather than as an attachment :)

Andrew, can you get this simple fix into your -mm tree ?

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
