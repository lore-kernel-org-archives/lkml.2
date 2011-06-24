Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759803Ab1FXQIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 12:08:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757887Ab1FXQIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 12:08:37 -0400
MIME-Version: 1.0
In-Reply-To: <20110624085318.70bde05c@jbarnes-desktop>
References: <20110623133740.0cdaf204@jbarnes-desktop> <BANLkTime_w_RLqU2dZV4zx9SEZaNTQoMNQ@mail.gmail.com>
 <20110624085318.70bde05c@jbarnes-desktop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 24 Jun 2011 09:07:46 -0700
Message-ID: <BANLkTinimDSWQaDcQj9nJj11juK2OCfLXg@mail.gmail.com>
Subject: Re: [git pull] PCI fixes
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 8:53 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>
> Some discussion was under "PCI: fix cardbus and sriov regressions",
> which includes a patchset as well. Oliver Hartkopp's problem is the one
> that worries me most. The SR-IOV issue is really a BIOS bug and
> unlikely to affect many people anyway (SR-IOV is really a big server
> feature).

Ouch. That is much bigger than I was hoping for. Especially that
second patch doesn't look like some -rc5 candidate.

And the fact that Oliver then at the end shows an impossibly aligned
resource shows that it clearly isn't even remotely correct even AFTER
the patches, so that doesn't make me get all warm and fuzzy either.

So I guess we should just revert again.

                         Linus
