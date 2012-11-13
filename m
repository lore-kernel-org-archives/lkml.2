Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab2KMBTB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 20:19:01 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39500 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab2KMBTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 20:19:00 -0500
Date: Mon, 12 Nov 2012 17:18:58 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Artem S. Tashkinov" <t.artem@lycos.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <dave@gnu.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: OOM changes in Linux 3.7 lead to udev warnings and total breakage
 of KDE 3.5.10/TDE
In-Reply-To: <CA+55aFz2Kgn0mVV4ozH0g1QGKw1VE6NpgCz9taxxfbCUz2a8VA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1211121717060.8225@chino.kir.corp.google.com>
References: <545706980.41498.1352739027798.JavaMail.mail@webmail19> <alpine.DEB.2.00.1211121339000.23347@chino.kir.corp.google.com> <CA+55aFz2Kgn0mVV4ozH0g1QGKw1VE6NpgCz9taxxfbCUz2a8VA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2012, Linus Torvalds wrote:

> The work-around might be as simple as creating an oom_adj file that
> simply doesn't do anything.
> 

You want to carry a dummy tunable forever?  If not, then how long if two 
years isn't sufficient?
