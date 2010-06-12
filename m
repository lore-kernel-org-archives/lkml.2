Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab0FLCut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 22:50:49 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55906 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258Ab0FLCur convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 22:50:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=jzlNkOmrZXyJSeKBAXlSHPD9WZgJJ1Y8VtgfKA6VPl0aA3K2UrcoNfky761zi5w4/n
         WL6wY8hoUIbA78UCjeEo1HYQnBe9sdlydMbfV/utG11yRT+ajLENKUtNGkfFI7AOAgNE
         6s3s4JgYlPplS9nI7ydRKsnx6mjuKuavYJSuc=
MIME-Version: 1.0
In-Reply-To: <AANLkTimkQeUWKcVUL2Lxq9OqeUimnZwvROdIfOFAZD-_@mail.gmail.com>
References: <AANLkTimkQeUWKcVUL2Lxq9OqeUimnZwvROdIfOFAZD-_@mail.gmail.com>
Date: Fri, 11 Jun 2010 20:50:45 -0600
Message-ID: <AANLkTin4ptXe0jcj30rlelBchPRyEKOxq3CFI1LmC9p8@mail.gmail.com>
Subject: Re: [ANNOUNCE] Open CWorthy Linux Libaries 6-11-2010 posted
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 8:49 PM, Jeffrey Merkey <jeffmerkey@gmail.com> wrote:
> Download is at:
>
> http://cworthylinux.googlecode.com/files/cworthy-06-11-2010.tar.gz
>
> FIXES
>
> Corrected pthread concurrency issues with ncurses and ncursesw.  These (THE NCURSES LIBS THAT IS)
> libraries are not pthread safe on linux 2.6.33 and later kernels and
> require mutexes for access to any of the screen
> refresh() calls or they will corrupt the video display
>
> removed vitriolic messages from the code and comments
>
> this version supports multiple update panels with pthread safe calls
> to ncurses libraries.  Supports VT100, VT220, XTerm, and Linux
> terminals.  Dumb terminal and ANSI still have some issues but these
> problems are ncurses related.  Sample IFCON program included.
>
> This version was tested on a 4 processor Opteron HP Proliant Server
>
> Jeff
>
