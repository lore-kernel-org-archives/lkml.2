Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab0IMIkN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 04:40:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40138 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab0IMIkM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 04:40:12 -0400
Subject: Re: [RFC PATCH] x86: don't compile with gcc-3.3.3
From: Peter Zijlstra <peterz@infradead.org>
To: florian@mickler.org
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1284366708-30154-1-git-send-email-florian@mickler.org>
References: <1284366708-30154-1-git-send-email-florian@mickler.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Sep 2010 10:39:55 +0200
Message-ID: <1284367195.2275.29.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 10:31 +0200, florian@mickler.org wrote:
> hpa commented on bug 16506[1] :
> "Please note that gcc-3.3.3 is known broken on x86; gcc-3.4 is the oldest
> version which is known to *not* be broken."
> 
> References: 
> 	[0]: https://bugzilla.kernel.org/show_bug.cgi?id=16633
> 	[1]: https://bugzilla.kernel.org/show_bug.cgi?id=16506#c28
> 
> If that is indeed so, we should abort the build? No?

Does it in fact still build with 3.4? I seem to recall some talk about
pushing the minimum version to 4.x for x86, although I can't remember
where..


