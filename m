Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab1G1KEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 06:04:38 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42345 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab1G1KEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 06:04:33 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1107221108190.2996@tiger>
References: <alpine.DEB.2.00.1107221108190.2996@tiger>
Date: Thu, 28 Jul 2011 13:04:32 +0300
X-Google-Sender-Auth: cYJxAl0T4DDkbiwG_rcpAf1qafo
Message-ID: <CAOJsxLHniS9Hx+ep_i2qbE_Oo6PnkNCK5dNARW5egg9Bso4Ovg@mail.gmail.com>
Subject: Re: [GIT PULL] SLAB changes for v3.1-rc0
From: Pekka Enberg <penberg@kernel.org>
To: torvalds@linux-foundation.org
Cc: cl@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 11:08 AM, Pekka Enberg <penberg@kernel.org> wrote:
> Please note that the SLUB lockless slowpath patches will be sent in a
> separate pull request.

Christoph, your debugging fix has been in linux-next for few days now
and no problem have been reported. I'm considering sending the series
to Linus. What do you think?

                        Pekka
