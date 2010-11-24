Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411Ab0KXHH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 02:07:27 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64320 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab0KXHH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 02:07:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=kt5R474JmUmExaNf3tcVz+f7FuMHYG2z9CwFMiRJ2IDm7SQbfSPvJKWeMOPAsTnOjz
         M5mA/UCf9msL6J1TVx2XjC3oUMmYAHYpfqO85Vt1fH7OCyLUsJSovcyaMPaEE5vmnYOf
         ZdnQ24QTCPFgNxFPCKWBPK9fJ8DI+jZQbv8kI=
MIME-Version: 1.0
In-Reply-To: <20101123235156.482244613@linux.com>
References: <20101123235139.908255844@linux.com>
	<20101123235156.482244613@linux.com>
Date: Wed, 24 Nov 2010 09:07:25 +0200
X-Google-Sender-Auth: s-1YDtFMlm3IKKs_gitv9cLE3yM
Message-ID: <AANLkTim=Gu3Hju-q7Qu-imEer5fCuwkJ8rwX3-9bL=Xu@mail.gmail.com>
Subject: Re: [thiscpuops upgrade 01/10] percpucounter: Optimize
 __percpu_counter_add a bit through the use of this_cpu() options.
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

On Wed, Nov 24, 2010 at 1:51 AM, Christoph Lameter <cl@linux.com> wrote:
> The this_cpu_* options can be used to optimize __percpu_counter_add a bit. Avoids
> some address arithmetic and saves 12 bytes.

[snip]

> Signed-off-by: Christoph Lameter <cl@linux.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
