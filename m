Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab1FCSHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 14:07:22 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47899 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab1FCSHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 14:07:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=jXI8y7kEfvgBLvevgDLcEn6IedMmlLRLTa7atUiaBuAeTCeA7dhvYkQJu78NoOdTZm
         KpRuaYBSmNgtqRo9rUtfzEzmIbyV96B7ZvhieNxKTI/fwvXvtOGhaBWRCPqQ3dbLDllv
         Bbi/ZcvutRbH16bsJ5fD4ULWdiQDocUx0Lrig=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1106030904320.27151@router.home>
References: <1306999002-29738-1-git-send-email-ssouhlal@FreeBSD.org>
	<alpine.DEB.2.00.1106021011510.18350@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1106030904320.27151@router.home>
Date: Fri, 3 Jun 2011 21:07:18 +0300
X-Google-Sender-Auth: ik4ijMwjoODdS9GKinRqBi0GRpg
Message-ID: <BANLkTimy2gLR-fuAgakwi91L=uuV9_4-rw@mail.gmail.com>
Subject: Re: [PATCH] SLAB: Record actual last user of freed objects.
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>,
        Suleiman Souhlal <ssouhlal@freebsd.org>, suleiman@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, mpm@selenic.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 3, 2011 at 5:05 PM, Christoph Lameter <cl@linux.com> wrote:
> On Thu, 2 Jun 2011, David Rientjes wrote:
>
>> On Thu, 2 Jun 2011, Suleiman Souhlal wrote:
>>
>> > Currently, when using CONFIG_DEBUG_SLAB, we put in kfree() or
>> > kmem_cache_free() as the last user of free objects, which is not
>> > very useful, so change it to the caller of those functions instead.
>> >
>> > Signed-off-by: Suleiman Souhlal <suleiman@google.com>
>>
>> Acked-by: David Rientjes <rientjes@google.com>
>
> Well note that this increases the overhead of a hot code path. But slub
> does the same
>
> Acked-by: Christoph Lameter <cl@linux.com>

Applied, thanks!
