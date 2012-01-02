Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab2ABVOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 16:14:47 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42861 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab2ABVOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 16:14:45 -0500
Date: Tue, 3 Jan 2012 01:14:39 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: bastien ROUCARIES <roucaries.bastien@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 1/4] Add routine for generating an ID for kernel pointer
Message-ID: <20120102211439.GC2621@moon>
References: <20111228170116.GQ17712@google.com>
 <4EFE4E89.6000607@gmail.com>
 <20111231075102.GQ4806@moon>
 <201201021318.15130.roucaries.bastien@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201201021318.15130.roucaries.bastien@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 02, 2012 at 01:18:13PM +0100, bastien ROUCARIES wrote:
> Le Saturday 31 December 2011 08:51:02, Cyrill Gorcunov a écrit :
> > On Fri, Dec 30, 2011 at 06:51:37PM -0500, KOSAKI Motohiro wrote:
> > ...
> > 
> > > >Guys, this become more and more complex, finally I fear someone
> > > >propose to do ideal hashing run-time ;) Maybe we can step back and
> > > >live with root-only and plain pointers here? I'm not sure who else
> > > >might need such facility except us, and if once there will be a
> > > >candidate -- we could take a look on hashing again and provide safe
> > > >hashes there. No?
> > > 
> > > But recently kernel security fashion are, we don't expose a kernel
> > > pointer at all even though the file is root only. I'm not sure how
> > > much effective such fashion. but you seems run opposite way.
> > > 
> > > I doubt user land can implement good comparison way. Why you gave up
> > > Andrew's sys_are_these_files_the_same() idea?
> 
> By memory, it seems that fuse expose kernel pointer encrypting it with tea.
> Tea is simple and quick you should get a glimpse at it.
> 

I've been advised to try aes as well with random cookie as a key.
I'll take a look once I've time to. Thanks!

	Cyrill
