Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759785Ab1FXQMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 12:12:00 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:60498 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754226Ab1FXQL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 12:11:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=c9RiaKyRQhJdgx0l/izYX1YrCx1IulI/qiy6NO1+pvd9u0C31/YzlVJPhiClO6CrgRKp4XsIc4aJRin2oxi3yt/SllYzHBxJzTuKi4+ze5AX6at+XRH41e75ZkXW9HOQ;
Date: Fri, 24 Jun 2011 09:11:48 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ram Pai <linuxram@us.ibm.com>, yinghai@kernel.org
Subject: Re: [git pull] PCI fixes
Message-ID: <20110624091148.18f8959d@jbarnes-desktop>
In-Reply-To: <BANLkTinimDSWQaDcQj9nJj11juK2OCfLXg@mail.gmail.com>
References: <20110623133740.0cdaf204@jbarnes-desktop>
	<BANLkTime_w_RLqU2dZV4zx9SEZaNTQoMNQ@mail.gmail.com>
	<20110624085318.70bde05c@jbarnes-desktop>
	<BANLkTinimDSWQaDcQj9nJj11juK2OCfLXg@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jun 2011 09:07:46 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, Jun 24, 2011 at 8:53 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> >
> > Some discussion was under "PCI: fix cardbus and sriov regressions",
> > which includes a patchset as well. Oliver Hartkopp's problem is the one
> > that worries me most. The SR-IOV issue is really a BIOS bug and
> > unlikely to affect many people anyway (SR-IOV is really a big server
> > feature).
> 
> Ouch. That is much bigger than I was hoping for. Especially that
> second patch doesn't look like some -rc5 candidate.
> 
> And the fact that Oliver then at the end shows an impossibly aligned
> resource shows that it clearly isn't even remotely correct even AFTER
> the patches, so that doesn't make me get all warm and fuzzy either.
> 
> So I guess we should just revert again.

How about a boot param?  We've done similar things for _CRS, and it
might give Yinghai and Ram some more flexibility in improving our
dynamic resource allocation before enabling it again (if ever).

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
