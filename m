Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552Ab2EUX04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 19:26:56 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62386 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab2EUX0y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 19:26:54 -0400
MIME-Version: 1.0
In-Reply-To: <20120521170539.GA13635@google.com>
References: <20120521170539.GA13635@google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 May 2012 16:26:32 -0700
X-Google-Sender-Auth: q2VAydd56chXo9oBEDF7p4306uQ
Message-ID: <CA+55aFyyEhYcoh2gugVJELfW+dGrLbrow=ZoXsPs3kxft7Tu4g@mail.gmail.com>
Subject: Re: [GIT PULL] PCI updates for 3.5 merge window
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 10:05 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>
> Please pull the signed tag "pci-for-3.5" to get these PCI changes for the
> v3.5 merge window.  I'm a newbie, so don't hesitate to help me improve my
> pull requests :)

Looks fine, except please actually mention the tag itself on the repo
pull line. IOW, not like this:

>  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git next

but simply

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/pci-for-3.5

otherwise it's much too easy for my to just cut-and-paste the line you
supplied without noticing that there was a tag mentioned earlier..

              Linus
