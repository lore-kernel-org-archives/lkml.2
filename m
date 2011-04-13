Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab1DMM42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 08:56:28 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61653 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab1DMM41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 08:56:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=L4xBdU+5pqJXNi3FXJgqtBdE1bi9IJckm3UTkvArtgLncxpWF94KPQYdCRaah/6PX1
         rAP0po+0VD9BKQ1nNoJn4mn9nz6iuDzF0upnnA4raQpnmr1L/dJO0DW9hUycE6b3eyyN
         G0dcDU8cnJSry/0Et0AS5VdGz4MiXZeqinYPQ=
MIME-Version: 1.0
In-Reply-To: <1302698512-11979-2-git-send-email-richard@nod.at>
References: <1302698512-11979-1-git-send-email-richard@nod.at>
	<1302698512-11979-2-git-send-email-richard@nod.at>
Date: Wed, 13 Apr 2011 15:56:26 +0300
X-Google-Sender-Auth: cQDhSUVD5eE3Lp3MaPteNTQeW48
Message-ID: <BANLkTikJ-7vHBBWSdTcz4mtB2ERqfn3D6g@mail.gmail.com>
Subject: Re: [PATCH 2/2] um: Disable CONFIG_CMPXCHG_LOCAL
From: Pekka Enberg <penberg@kernel.org>
To: Richard Weinberger <richard@nod.at>
Cc: akpm@linux-foundation.com, slyich@gmail.com, linux-kernel@vger.kernel.org,
        jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
        Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 3:41 PM, Richard Weinberger <richard@nod.at> wrote:
> Commit 8a5ec0ba "Lockless (and preemptless) fastpaths for slub"
> makes use of this_cpu_cmpxchg_double() which needs
> this_cpu_cmpxchg16b_emu() on x86_64.
> Implementing cmpxchg16b emulation for UML would introduce
> too much complexity. So just disable it.
>
> LKML-Reference: <20110412192014.GF16342@mtj.dyndns.org>
> Reported-by: Sergei Trofimovich <slyich@gmail.com>
> Signed-off-by: Richard Weinberger <richard@nod.at>

Acked-by: Pekka Enberg <penberg@kernel.org>
