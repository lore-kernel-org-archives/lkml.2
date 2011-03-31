Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629Ab1CaQOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 12:14:09 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:36616 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758568Ab1CaQOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 12:14:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=lI+DYKk20cUGzg/lTP5rW8KPmaDonoTi6Jfc8ab4XnRy7FQhlCBKwRf6g3IE+aWspH/etHShkq43eoaRwyZzVXj8SCHIXVX+N2oo2/IzrMuufBT5J7YYfd+y1+OkCnv5;
Date: Thu, 31 Mar 2011 09:14:01 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        bp@amd64.org, tglx@linutronix.de, borislav.petkov@amd.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, amd-nb: Rename CPU PCI id define for F4
Message-ID: <20110331091401.64f2c81c@jbarnes-desktop>
In-Reply-To: <20110331160552.GD9827@elte.hu>
References: <20110330183447.GA3668@aftab>
	<tip-cb6c8520f6f6bba7b7e1a6de3360a8edfd8243b6@git.kernel.org>
	<20110331090039.12358ee6@jbarnes-desktop>
	<20110331160552.GD9827@elte.hu>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011 18:05:52 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> 
> > On Thu, 31 Mar 2011 07:04:41 GMT
> > tip-bot for Borislav Petkov <bp@amd64.org> wrote:
> > 
> > > Commit-ID:  cb6c8520f6f6bba7b7e1a6de3360a8edfd8243b6
> > > Gitweb:     http://git.kernel.org/tip/cb6c8520f6f6bba7b7e1a6de3360a8edfd8243b6
> > > Author:     Borislav Petkov <bp@amd64.org>
> > > AuthorDate: Wed, 30 Mar 2011 20:34:47 +0200
> > > Committer:  Ingo Molnar <mingo@elte.hu>
> > > CommitDate: Thu, 31 Mar 2011 08:51:38 +0200
> > > 
> > > x86, amd-nb: Rename CPU PCI id define for F4
> > > 
> > > With increasing number of PCI function ids, add the PCI function
> > > id in the define name instead of its symbolic name in the BKDG
> > > for more clarity. This renames function 4 define.
> > > 
> > 
> > I guess I don't see how a rename is urgent, but you can add my
> > Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> 
> The new ID went upstream via cb293250c71f in the merge window, so i wanted to 
> shorten the life-time of the obsoleted name - that will also reduce the chance 
> of any conflicts.

Sounds good, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
