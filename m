Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934357Ab2FHQxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 12:53:50 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50127 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760681Ab2FHQxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 12:53:46 -0400
Date: Fri, 8 Jun 2012 17:57:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Len Brown <lenb@kernel.org>, linux-acpi <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] ACPI & Power Management Patches for Linux-3.5-rc1
Message-ID: <20120608175723.6dfc75f7@pyramind.ukuu.org.uk>
In-Reply-To: <CA+55aFzvj_0+kunG0fy1xDsTxrO-qBU7rg-6mpnFKoLq7XyROw@mail.gmail.com>
References: <4FCCD58B.30000@kernel.org>
	<CA+55aFzvj_0+kunG0fy1xDsTxrO-qBU7rg-6mpnFKoLq7XyROw@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Alan? Can you check out the tree at
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux.git release
> 
> or are you still busy with the queen?

Nope. Just missed the email. Len poked me about it now. You are correct
that the acpi_video_register should be back as per the later commit - it
got re-enabled.

I spent the holiday avoiding the English queen's party and turning from a
republican into a raving republican 8).

Alan


