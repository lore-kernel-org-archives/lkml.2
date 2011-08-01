Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab1HAMGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 08:06:23 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40074 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab1HAMGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 08:06:19 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1107311426001.944@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1107290145080.3279@tiger>
	<alpine.DEB.2.00.1107291002570.16178@router.home>
	<alpine.DEB.2.00.1107311136150.12538@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1107311253560.12538@chino.kir.corp.google.com>
	<1312145146.24862.97.camel@jaguar>
	<alpine.DEB.2.00.1107311426001.944@chino.kir.corp.google.com>
Date: Mon, 1 Aug 2011 15:06:19 +0300
X-Google-Sender-Auth: 4aB3O-M9u433100r7enrUzmZUS4
Message-ID: <CAOJsxLHB9jPNyU2qztbEHG4AZWjauCLkwUVYr--8PuBBg1=MCA@mail.gmail.com>
Subject: Re: [GIT PULL] Lockless SLUB slowpaths for v3.1-rc1
From: Pekka Enberg <penberg@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, hughd@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 1, 2011 at 12:55 AM, David Rientjes <rientjes@google.com> wrote:
> I'm very confident that slub could beat slab on any system if you throw
> enough memory at it because its fastpaths are extremely efficient, but
> there's no business case for that.

Btw, I haven't measured this recently but in my testing, SLAB has
pretty much always used more memory than SLUB. So 'throwing more
memory at the problem' is definitely a reasonable approach for SLUB.

                        Pekka
