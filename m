Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab2IHWpy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 18:45:54 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50112 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943Ab2IHWpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 18:45:52 -0400
MIME-Version: 1.0
In-Reply-To: <00000139a801aba3-4616277c-d845-4b62-83ec-1a1950b05751-000000@email.amazonses.com>
References: <CALF0-+VMtUPuLHg3CwDxFm-TjbN1=YavGO79Oo3GuymOLvikeA@mail.gmail.com>
	<00000139a801aba3-4616277c-d845-4b62-83ec-1a1950b05751-000000@email.amazonses.com>
Date: Sat, 8 Sep 2012 19:45:51 -0300
Message-ID: <CALF0-+U=sFgynE__V-XTN1SAgJHV_3VigRrdxuXFinbiWPg2oQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/10] mm: SLxB cleaning and trace accuracy improvement
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, JoonSoo Kim <js1304@gmail.com>,
        Tim Bird <tim.bird@am.sony.com>, Steven Rostedt <rostedt@goodmis.org>,
        David Rientjes <rientjes@google.com>,
        Glauber Costa <glommer@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph,

On Sat, Sep 8, 2012 at 7:30 PM, Christoph Lameter <cl@linux.com> wrote:
> On Sat, 8 Sep 2012, Ezequiel Garcia wrote:
>
>> This is the second spin of my patchset to clean SLxB and improve kmem
>> trace events accuracy.
>
> Please redo the patches on top of the patchsets that create
> mm/slab_common.c. You will be able to extract a lot more common code and
> help the goal of having as much common code as possible. PLease move as
> much as possible of the common functions into slab_common.c
>

Ah, I wasn't sure where to base my patches. I can split this patchset in two and
base the SLAB/SLUB commonize part on top of your tree, or perhaps just
based everything on top of your tree.

Is it this one?
http://west.gentwo.org/gitweb/?p=christoph;a=shortlog;h=refs/heads/common

I have to admit I started thinking of this commonization after seeing
your common
code patches.

Thanks!
Ezequiel.
