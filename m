Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab2EWQlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:41:17 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40165 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab2EWQlP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:41:15 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyyEhYcoh2gugVJELfW+dGrLbrow=ZoXsPs3kxft7Tu4g@mail.gmail.com>
References: <20120521170539.GA13635@google.com>
	<CA+55aFyyEhYcoh2gugVJELfW+dGrLbrow=ZoXsPs3kxft7Tu4g@mail.gmail.com>
Date: Wed, 23 May 2012 09:41:13 -0700
Message-ID: <CA+8MBbJ00Kgycu-7v6vofQYst_Cujoiu78_Ke5RqM6Bx=-+F1g@mail.gmail.com>
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

On Mon, May 21, 2012 at 4:26 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Looks fine, except please actually mention the tag itself on the repo
> pull line. IOW, not like this:
>
>>  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git next
>
> but simply
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/pci-for-3.5

git request-pull seems to look for branches before tags when generating
this text.  It just did exactly the same thing for me (since the tag I created
also pointed to my "next" branch).

This would seem to be the common case for people following the rules
and sending you stuff in the merge window that they have had cooking
in linux-next.  Can "request-pull" be smarter - or is their some magic I should
be using on the "git request-pull" command line that will tell it that I really
mean the tag and not the branch?

Or is "smarter" already in a newer version of git - I have:

$ git --version
git version 1.7.9.5

-Tony
