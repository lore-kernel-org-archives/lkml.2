Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab2D3GfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 02:35:17 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49773 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab2D3GfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 02:35:15 -0400
MIME-Version: 1.0
In-Reply-To: <4F9AFD28.2030801@hp.com>
References: <1335466658-29063-1-git-send-email-Waiman.Long@hp.com>
	<alpine.DEB.2.00.1204270911080.29198@router.home>
	<4F9AFD28.2030801@hp.com>
Date: Mon, 30 Apr 2012 09:35:14 +0300
X-Google-Sender-Auth: 6CjldJu1Qih0eyebqPaq4Wbb9O4
Message-ID: <CAOJsxLGXZsq22LuNa5ef5iv7Jy0A0w_S2MbDQeBW=dFvUwFRjA@mail.gmail.com>
Subject: Re: [PATCH] slub: prevent validate_slab() error due to race condition
From: Pekka Enberg <penberg@kernel.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Christoph Lameter <cl@linux.com>, "mpm@selenic.com" <mpm@selenic.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Morris, Donald George (HP-UX Cupertino)" <don.morris@hp.com>,
        David Rientjes <rientjes@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 11:10 PM, Waiman Long <waiman.long@hp.com> wrote:
> Thank for the quick response. I have no problem for moving the node-lock
> taking into free_debug_processing. Of the 2 problems that are reported, this
> is a more serious one and so need to be fixed sooner rather than later. For
> the other one, we can take more time to find a better solution.
>
> So are you going to integrate your change to the mainline?

Christoph, can you send the patch with an improved changelog that also
explains what the problem is?

How far back in the stable series do we want to backport this?
