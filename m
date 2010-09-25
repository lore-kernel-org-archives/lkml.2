Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab0IYAwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 20:52:42 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:33606 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754570Ab0IYAwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 20:52:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=O0piEWZZ4UATbeBgba7xHUqNeBb6Y97AV4Y804nfSYdHKq9gI1ThuTkcXZbkSdW8nRRV748lUWb6zPtwCSU+MhzjMnaO0se7ubgubRflYSYppVmRK/egg5bOWDZdZRDi;
Date: Fri, 24 Sep 2010 17:52:35 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Greg KH <greg@kroah.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Brian Bloniarz <phunge0@hotmail.com>,
        Charles Butterfield <charles.butterfield@nextcentury.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stefan Becker <chemobejk@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [stable] [PATCH v2 0/4] PCI: allocate space top-down, not
 bottom-up
Message-ID: <20100924175235.4f3db288@jbarnes-desktop>
In-Reply-To: <20100924234020.GA20601@kroah.com>
References: <20100917223109.24687.17697.stgit@bob.kio>
	<201009241641.40867.bjorn.helgaas@hp.com>
	<20100924234020.GA20601@kroah.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Sep 2010 16:40:20 -0700
Greg KH <greg@kroah.com> wrote:

> On Fri, Sep 24, 2010 at 04:41:39PM -0600, Bjorn Helgaas wrote:
> > Added cc: stable@kernel.org
> > See:
> >   https://patchwork.kernel.org/patch/189182/
> >   https://patchwork.kernel.org/patch/189232/
> >   https://patchwork.kernel.org/patch/189242/
> >   https://patchwork.kernel.org/patch/189252/
> 
> Um, why would -stable want them if they aren't in Linus's tree yet?
> Please, when they are in his tree, _AND_ have gotten a lot of testing,
> then email the git commit ids of what you want added to the stable tree
> to stable@kernel.org.
> 
> Doing it beforehand like this is a sure way to cause me a lot of work
> and the patches to be lost.

Yeah sorry.  They're queued up in a special branch atm, but will be
part of my initial 2.6.37 merge request pull.  They're not going into
2.6.36 because they're a bit too invasive for this late in the process.

I don't *think* they'll cause problems (ultimately they should make us
behave a bit more like Windows as far as resource allocation goes) so
hopefully a merge into stable sometime after the 2.6.37 merge window
closes won't be a problem, but you probably don't have a nice way of
automating that...

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
