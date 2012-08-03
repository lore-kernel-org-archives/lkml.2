Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab2HCNLl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 09:11:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52133 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab2HCNLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 09:11:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] kbuild: kvm: make export of linux/kvm_para.h unconditional
Date: Fri, 3 Aug 2012 13:11:32 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Will Deacon <will.deacon@arm.com>, Avi Kivity <avi@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
References: <1343310254-7493-1-git-send-email-will.deacon@arm.com> <20120803125144.GD26925@mudshark.cambridge.arm.com> <20120803130230.GA9812@merkur.ravnborg.org>
In-Reply-To: <20120803130230.GA9812@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208031311.33228.arnd@arndb.de>
X-Provags-ID: V02:K0:/j8H6OXconneZbcJZoxWnNRhLpLl8MQRmoS4tXsxF+Q
 rTsefBW4oQo2frE+KSXhjvA3zW91FkPYlm8HgpEVX4ddRH2Flp
 O7Y/+VrkRzNrdhKTUKi6+J1Lct7xmZFY0KtAVvD3wYN1eBF62N
 cBKITiWfloCmea2u2cYflDZT5u5ForN0JxbOdJzYkkNFbuH95E
 Vkn07ch7WfjJoJygVyVdm9EUKTW6A+ypZsW1ujRsC/CY1de6yq
 AqRf5gm/OpnuAHErzgVAhNSTFyVt4BLJj7cFrad1ReoagRj4Ue
 Ush9gJ+z+hAWV88/ATBniTh3DXavlla6M9pztVwhDBagh2OUmR
 KB9dONbKwEHluSQ1POv4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 August 2012, Sam Ravnborg wrote:
> > > I know we here hit a bad thing with the generic-y support,
> > > where we miss a good way to add a file to a lot of archs
> > > without editing a lot of files.
> > 
> > If there isn't a generic version of the header, then yes, I guess you have
> > to modify the architectures that want to export it.
> > 
> > I'm happy to post an extra patch sorting out kvm.h and a.out.h if that's
> > what's required to get headers building again.
> 
> IMO this is required to sort this out for good.
> I will be happy to review your patches.

I also owe Mark Brown a solution for the asm/clkdev.h redirect,
as by http://lkml.indiana.edu/hypermail/linux/kernel/1207.0/01141.html

I would very much like to avoid adding another wildcard logic for
generic-y, but I could not figure out how to do that better.

	Arnd
