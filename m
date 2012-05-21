Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759008Ab2EUSyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 14:54:23 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61090 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756686Ab2EUSyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 14:54:21 -0400
MIME-Version: 1.0
In-Reply-To: <20120521185202.GA6486@merkur.ravnborg.org>
References: <20120521.050300.1434374935904126254.davem@davemloft.net>
 <CA+55aFzag=LfduvHSmE34nEVYOk=MRhUMzK854+icLwthmz5Ng@mail.gmail.com>
 <20120521182400.GA6043@merkur.ravnborg.org> <CA+55aFymRE-_1qzCA_n3xYbMseQrZsjJWWX74S3jn5Qyf9Efjw@mail.gmail.com>
 <CA+55aFy4He9X6wQjATaJukzH1FkyhGqnmC4kb+azKuMmjPGbmg@mail.gmail.com> <20120521185202.GA6486@merkur.ravnborg.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 May 2012 11:54:00 -0700
X-Google-Sender-Auth: wDT7hEfC4wnZjwf_1_yZGcTp6EM
Message-ID: <CA+55aFwo6XusR8pNY+dp_5uFNqCxZjeWWL6h+V=PFqT884Qc_A@mail.gmail.com>
Subject: Re: [PATCH] net: drop NET dependency from HAVE_BPF_JIT
To: Sam Ravnborg <sam@ravnborg.org>
Cc: netdev <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 11:52 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
>
> Fix up all users to drop the dependency on NET now that
> it is not required to supress warnings for non-NET builds.

Do you want me to take this directly, or will it go through the net
tree? I can live with it either way.

               Linus
