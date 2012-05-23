Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933715Ab2EWRfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 13:35:34 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:43966 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760659Ab2EWRfd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 13:35:33 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzgMPobmuCM86Z2obEnEB=uTA4n8VQQJUZoQsW8oTS7gA@mail.gmail.com>
References: <20120521170539.GA13635@google.com>
	<CA+55aFyyEhYcoh2gugVJELfW+dGrLbrow=ZoXsPs3kxft7Tu4g@mail.gmail.com>
	<CA+8MBbJ00Kgycu-7v6vofQYst_Cujoiu78_Ke5RqM6Bx=-+F1g@mail.gmail.com>
	<CA+55aFzgMPobmuCM86Z2obEnEB=uTA4n8VQQJUZoQsW8oTS7gA@mail.gmail.com>
Date: Wed, 23 May 2012 10:35:32 -0700
Message-ID: <CA+8MBbJwXELb1Q4ZaD8HhtNqXyv1WJiJC0omERa0Gmffov1qQA@mail.gmail.com>
Subject: Re: [GIT PULL] PCI updates for 3.5 merge window
From: Tony Luck <tony.luck@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 9:52 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> I would strongly recommend just doing
>
>   git clone git://github.com/gitster/git
>   cd git
>   make
>   make install

My distro needed some "curl" and "expat" bits added ... but that worked
and I now have shiny new:
$ git --version
git version 1.7.10.2.552.gaa3bb87

which does indeed have a smarter git request-pull.

Thanks

-Tony
