Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690Ab1JZKMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 06:12:50 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65330 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932647Ab1JZKMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 06:12:49 -0400
MIME-Version: 1.0
In-Reply-To: <DB904C5425BA6F4E8424B3B51A1414D16D3BA94A82@NWD2CMBX1.ad.analog.com>
References: <1319606151-29707-1-git-send-email-sonic.adi@gmail.com>
 <CAJaTeTqsjjjS=Myt_gfPzOfF4mzqZ1pz2NJE95Gq6g_O0aOijA@mail.gmail.com> <DB904C5425BA6F4E8424B3B51A1414D16D3BA94A82@NWD2CMBX1.ad.analog.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Wed, 26 Oct 2011 06:12:29 -0400
X-Google-Sender-Auth: L9cNM3cZFemNqPZBaGfDFV8WjJA
Message-ID: <CAJaTeTpbeAmTXX_Tf7WnGha9o-3u47Y3GABzkqk11ECk72HLXw@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [PATCH] mutex:SMP:bf561:Run smp memory
 barrier after take atomic lock in mutex_fastpath APIs.
To: "Zhang, Sonic" <Sonic.Zhang@analog.com>
Cc: Sonic Zhang <sonic.adi@gmail.com>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 04:53, Zhang, Sonic wrote:
> Our SMP atomic implementation doesn't include memory barrier. Is it a better way to add barrier there?

i'll have to re-read the thread myself, but i thought the conclusions
of that thread were implemented in the Blackfin tree now

so if the conclusion was we needed barriers in the atomic funcs, and
we don't have them now, then that probably is the way to go instead
... but i'll have to review things in depth later
-mike
