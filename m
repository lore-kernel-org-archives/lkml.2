Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab0KXHFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 02:05:05 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49321 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab0KXHFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 02:05:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=tblhKyMhNDe6+Eji9lOv4YU/xHKTlFqTqpFv420ZOBqPe+tRJc1JW55Pktq4pynNbh
         tx49VdhyQIQOCNmgBH/Xd+rpsDZA3APJAoPGZteh3Hm/38FwiNAXcexc0GY0yxtmnUlH
         0Wwyr/uxK1AJVXdrN/U2Qlzjq3tDV118Q4DRU=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1011232110540.7446@router.home>
References: <20101123235139.908255844@linux.com>
	<20101123235201.146063796@linux.com>
	<1290559301.2866.129.camel@edumazet-laptop>
	<alpine.DEB.2.00.1011232110540.7446@router.home>
Date: Wed, 24 Nov 2010 09:05:02 +0200
X-Google-Sender-Auth: btQyz9XgFrfJjgyXQn8G0r1sryI
Message-ID: <AANLkTikVhqdxD67C-g39pANSddSUi8uWygHd_iTM3iu-@mail.gmail.com>
Subject: Re: [thiscpuops upgrade 09/10] x86: this_cpu_cmpxchg and
 this_cpu_cmpxchg_double operations
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Nov 2010, Eric Dumazet wrote:
>> You have to check cx16 feature flag or implement a fallback ?

On Wed, Nov 24, 2010 at 5:11 AM, Christoph Lameter <cl@linux.com> wrote:
> There is already a compile time fallback. Uhh.. How do I do this at
> runtime?

I think the CPU alternatives API is meant for just that. Grep for
"alternative" in arch/x86.
