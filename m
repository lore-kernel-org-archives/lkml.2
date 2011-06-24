Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759795Ab1FXPxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 11:53:33 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:34265 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759332Ab1FXPxc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 11:53:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=hlRRIwi7O9GSyDHnqHVIylQhWlpXud0828teaPHeEcHng83lJl9fCdbB38Tu0YsiDn5rv3xa1F0YTnVzyBTcHq7RLW3Us21chRdfX9xyGxiZM5LW1blXRhGv8LTzGqtW;
Date: Fri, 24 Jun 2011 08:53:18 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] PCI fixes
Message-ID: <20110624085318.70bde05c@jbarnes-desktop>
In-Reply-To: <BANLkTime_w_RLqU2dZV4zx9SEZaNTQoMNQ@mail.gmail.com>
References: <20110623133740.0cdaf204@jbarnes-desktop>
	<BANLkTime_w_RLqU2dZV4zx9SEZaNTQoMNQ@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jun 2011 08:38:07 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Jun 23, 2011 at 1:37 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> >
> > Just a few minor fixes.  We have one open issue with the resource
> > re-allocation code that was re-added.  Ram has a fix but I'm concerned
> > it will introduce other regressions.  So at this point we have a few
> > options:
> >  - revert the bridge resource re-allocation code (again)
> >  - hide the re-allocation code behind a new kernel option (and not
> >    try=!), this would at least let us experiment with new strategies
> >    and PNP resource tracking etc
> >  - apply Ram's patch and revert it all later if things are still broken
> 
> I think I've missed the regression discussion, so can you forward a
> description and the fix?
> 
> I have to admit that I'm inclined to try the fix if it's clean, just
> in the hope to get over this finally. But I'd like to see  what the
> problem/fix is...
> 
> Maybe I've seen it and just didn't react.

Some discussion was under "PCI: fix cardbus and sriov regressions",
which includes a patchset as well. Oliver Hartkopp's problem is the one
that worries me most. The SR-IOV issue is really a BIOS bug and
unlikely to affect many people anyway (SR-IOV is really a big server
feature).

-- 
Jesse Barnes, Intel Open Source Technology Center
