Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab0HYNvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 09:51:49 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:34107 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab0HYNvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 09:51:48 -0400
Date: Wed, 25 Aug 2010 15:51:14 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Daniel Kiper <dkiper@net-space.pl>, "H. Peter Anvin" <hpa@zytor.com>,
        mingo@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, apic: Fix apic=debug boot crash
Message-ID: <20100825135114.GA7307@router-fw-old.local.net-space.pl>
References: <20100819224616.GB9967@router-fw-old.local.net-space.pl> <tip-05e407603e527f9d808dd3866d3a17c2ce4dfcc5@git.kernel.org> <AANLkTim9kjBp68LqieU3MDLbkRDiWLNQjtUvjEbc9Hca@mail.gmail.com> <20100823081212.GA13297@router-fw-old.local.net-space.pl> <9cca0990-1b78-40e7-a71d-f550b4f504aa@email.android.com> <4C72B6F7.8010706@kernel.org> <20100824213931.GA1192@router-fw-old.local.net-space.pl> <4C743E00.1040601@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C743E00.1040601@kernel.org>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 24, 2010 at 02:47:44PM -0700, Yinghai Lu wrote:
[...]
> I mean you should figure out why xen ops could have null cfg.

OK, I will check that next week.

Daniel
