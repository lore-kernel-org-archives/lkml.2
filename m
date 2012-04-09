Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab2DITZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 15:25:51 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51422 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757635Ab2DITZt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 15:25:49 -0400
MIME-Version: 1.0
In-Reply-To: <1540670.AFBi1SpGoi@sifl>
References: <1540670.AFBi1SpGoi@sifl>
Date: Mon, 9 Apr 2012 15:25:48 -0400
Message-ID: <CA+5PVA42YNwM2_pUS=EYrk88ih1wbHXtL56C73hdxVz6J4bgTA@mail.gmail.com>
Subject: Re: ANN: libseccomp
From: Josh Boyer <jwboyer@gmail.com>
To: Paul Moore <paul@paul-moore.com>
Cc: libseccomp-discuss@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 9, 2012 at 2:58 PM, Paul Moore <paul@paul-moore.com> wrote:
> With the seccomp patches finally stabilizing a bit, it seems like now is a
> good time to announce libseccomp: a library designed to make it easier to
> create complex, architecture independent seccomp filters.
>
>  * http://sourceforge.net/projects/libseccomp/
>  * git clone git://git.code.sf.net/p/libseccomp/libseccomp
>
> The library has only been in development for the past couple months, so it may
> be a little rough around the edges, and definitely could use more testing, but
> it is functional and has had some basic testing against the seccomp v17
> patches.  The project currently lacks any online documentation or a website
> beyond the basic SF.net tools, but there are current man pages in the source
> repository and the code is reasonably well commented.

Do you think the GPLv2 license will limit adoption of it's usage across
a wider variety of software projects?  I'm not anti-GPL by any means
but I am slightly surprised libseccomp is using it.

josh
