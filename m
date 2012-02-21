Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751207Ab2BUFV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 00:21:28 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:41721 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab2BUFV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 00:21:27 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.101.37 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <CA+55aFwBD7pbOcSUVguF+vFAs85JhNpjJgZtDKjEJA0PVXrhkw@mail.gmail.com>
References: <CA+55aFy2pnoNhpTstAMTs+dtm5iRaGCGKLwW6ScCLhEkWtHXGw@mail.gmail.com>
 <FE1DCD87-0055-4C3E-B06A-251055E1492F@m3y3r.de> <CA+55aFzUWDEuj85sOKjwk8ufy+1rbS7hgstw0cCWpjTgu=7B4A@mail.gmail.com>
 <20120219.144947.660678318380307878.davem@davemloft.net> <CA+55aFwqChUmmDfoYX7HRUUZg5s7nBOh834=g+7avj=yc42gGg@mail.gmail.com>
 <1329794974.2226.11.camel@perseus.themaw.net> <CA+55aFxDXcgOHRk5aPV5aGEDT3chXgcq_ktHKutk7OcyRjDUUw@mail.gmail.com>
 <1329796956.2226.20.camel@perseus.themaw.net> <CA+55aFzVyr_U0-2Df2bqcX7G6DvkEGp=1N+ck4=EHuq=NY0Wkw@mail.gmail.com>
 <1329799959.2226.32.camel@perseus.themaw.net> <CA+55aFwBD7pbOcSUVguF+vFAs85JhNpjJgZtDKjEJA0PVXrhkw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 20 Feb 2012 21:21:06 -0800
X-Google-Sender-Auth: g8JZMUL3Ow7uswpOt0sV7Gwxtww
Message-ID: <CA+55aFzcWjPrK4csbThuGimt6bHC+bcgFhj-r8d3M1MxhN_HKg@mail.gmail.com>
Subject: Re: Linux 3.3-rc4
To: Ian Kent <raven@themaw.net>
Cc: David Miller <davem@davemloft.net>, thomas@m3y3r.de,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 9:06 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So it really is limited to only x86.

Oh, and if people really are using "uname()" to figure out that they
are running a 64-bit kernel, then we should probably make uname() use
"is_compat_task()" instead of checking the PER_LINUX32 personality.

So we already do have support for returning a different machine-name
to 32-bit binaries, but it uses the "personality" thing that nobody
cares about, rather than the compat layer. Looks like purely
historical reasons.

               Linus
