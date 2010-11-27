Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab0K0IHP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 03:07:15 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:63049 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab0K0IHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 03:07:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=CXdIfJewfvGICCdbSAt48T17P8p/p038DcFEpzwyRh8L9+gNuKozSf6+X95B+DWrnb
         392MaB2/5JTGHPLjKfAV6fxdk1YKRCoNE3o0ARQ796UMRzNSZBMjS00q8GjZP8aMT2T0
         tvEicrOL5iMbisY0ovmUEHo2JRqeJknWcmHY8=
MIME-Version: 1.0
In-Reply-To: <20101126210951.874368925@linux.com>
References: <20101126210937.383047168@linux.com>
	<20101126210951.874368925@linux.com>
Date: Sat, 27 Nov 2010 10:07:12 +0200
X-Google-Sender-Auth: 3c5pc_TystZwEqNhOo8Tv7nKVVo
Message-ID: <AANLkTinvcof2+rAa64AUFPaU0QeXC0EuzZy=QD9Fcdcq@mail.gmail.com>
Subject: Re: [thisops uV2 05/10] x86: Use this_cpu_inc_return for nmi counter
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 11:09 PM, Christoph Lameter <cl@linux.com> wrote:
> this_cpu_inc_return() saves us a memory access there.
>
> Reviewed-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Christoph Lameter <cl@linux.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
