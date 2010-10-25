Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144Ab0JYVCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 17:02:00 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:45629 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751995Ab0JYVB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 17:01:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Zc/jZ39JXGfEeWKsI4rgveYJtzmT2Zr93l090nAgSr8U91igDl4L13cYAxH2fCI41Qyo20fejjyL1o6jaODZyYstCPl+Q5NTdWEhLSLGf+K+5UTHNYiRpiEaxBPKhSg3;
Date: Mon, 25 Oct 2010 14:01:54 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Bob Picco <bpicco@redhat.com>, Brian Bloniarz <phunge0@hotmail.com>,
        Charles Butterfield <charles.butterfield@nextcentury.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-pci@vger.kernel.org,
        "Horst H. von Brand" <vonbrand@inf.utfsm.cl>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Stefan Becker <chemobejk@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Leann Ogasawara <leann.ogasawara@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v4 6/6] x86: allocate space within a region top-down
Message-ID: <20101025140154.66f1e1bd@jbarnes-desktop>
In-Reply-To: <20101014231852.536.42958.stgit@bob.kio>
References: <20101014231804.536.62138.stgit@bob.kio>
	<20101014231852.536.42958.stgit@bob.kio>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Oct 2010 17:18:52 -0600
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> 
> Request that allocate_resource() use available space from high addresses
> first, rather than the default of using low addresses first.
> 
> The most common place this makes a difference is when we move or assign
> new PCI device resources.  Low addresses are generally scarce, so it's
> better to use high addresses when possible.  This follows Windows practice
> for PCI allocation.

Applied this series to linux-next; assuming nothing blows up I'll send
it to Linus this week (previous versions got some testing and landed in
a separate branch so this should be fine).

-- 
Jesse Barnes, Intel Open Source Technology Center
