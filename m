Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab0EZQ6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 12:58:30 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64457 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab0EZQ62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 12:58:28 -0400
Date: Wed, 26 May 2010 09:56:06 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Michal Marek <mmarek@suse.cz>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, matt mooney <mfm@muteddisk.com>,
       Kirill Smelkov <kirr@mns.spb.ru>
Subject: Re: linux-next: manual merge of the kbuild tree with the kernel-doc
 tree
Message-Id: <20100526095606.beed820e.randy.dunlap@oracle.com>
In-Reply-To: <20100527025020.da0c1bb7.sfr@canb.auug.org.au>
References: <20100526115346.da5a02aa.sfr@canb.auug.org.au>
	<4BFD42A6.6060206@oracle.com>
	<20100527025020.da0c1bb7.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090203.4BFD5317.0113:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010 02:50:20 +1000 Stephen Rothwell wrote:

> Hi Randy,
> 
> On Wed, 26 May 2010 08:47:50 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> >
> > On 05/25/10 18:53, Stephen Rothwell wrote:
> > > 
> > > Today's linux-next merge of the kbuild tree got a conflict in
> > > Documentation/kbuild/makefiles.txt between commit
> > > 74bb7003010ff0998e280a6ade09381168ff20ec
> > > ("docs-kbuild-make-examples-content2") from the kernel-doc tree and
> > > commit e8d400a933fa44e2fba3849b084e1ae5814d7fca ("kbuild: fix a couple of
> > > typos in Documentation") from the kbuild tree.
> > > 
> > > The former also fixed the typo, so I used that.
> > 
> > If Michal has merged it, I'll drop it.
> > 
> > Michal, can I view your tree by using gitweb?  (i.e., http)
> > or is it only accessible by pulling/cloning?
> 
> The kernel-doc tree is a quilt series :-(

Yes.  and it's viewable without pulling/cloning.  ;)

> You can, of course, see the above commit in the linux-next tree via
> gitweb on kernel.org.

Thanks.  Michal, I droppped these 3 patches.  Please keep them in the
kbuild tree.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
