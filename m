Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab2CMNlD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 09:41:03 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64714 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab2CMNlB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 09:41:01 -0400
MIME-Version: 1.0
In-Reply-To: <CACVxJT_UWzpVo1Jfbf5Z2A-s16QjEv05MiNSY_EGihKTPuMyxg@mail.gmail.com>
References: <CACVxJT_UWzpVo1Jfbf5Z2A-s16QjEv05MiNSY_EGihKTPuMyxg@mail.gmail.com>
Date: Tue, 13 Mar 2012 15:41:00 +0200
Message-ID: <CACVxJT8nG3QNMAQ3rA0hp11x=ARgJEkHS408TPeL_3SH7cwZFg@mail.gmail.com>
Subject: Re: seq_put_decimal_ull() et al
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 4:35 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
>> Subject:    + procfs-add-num_to_str-to-speed-up-proc-stat-fix-2.patch added to -mm tree
>
> I think the fix is to create proper binary interface for exporting
> interrupt counts.
> Programs can parse raw data equally well if programming language is
> even minimally reasonable
> (POSIX shell may not qualify, though).

Ugh, I meant a file with binary data, not complete fileless interface.
