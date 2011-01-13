Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab1AMV3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 16:29:32 -0500
Received: from tundra.namei.org ([65.99.196.166]:48865 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085Ab1AMV3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 16:29:25 -0500
Date: Fri, 14 Jan 2011 08:29:22 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Security subsystem changes for 2.6.38
In-Reply-To: <AANLkTik1kxC_GBKYSvhAK6_O0Bt-ALbEP3T=+AmMQRLP@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1101140826340.27060@tundra.namei.org>
References: <alpine.LRH.2.00.1101101136001.21289@tundra.namei.org> <AANLkTinU2mNyTEc55=ypDPXWah_ozaV1BHWBqCenxp1Z@mail.gmail.com> <alpine.LRH.2.00.1101110855330.28785@tundra.namei.org> <AANLkTik1kxC_GBKYSvhAK6_O0Bt-ALbEP3T=+AmMQRLP@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jan 2011, Linus Torvalds wrote:

> On Mon, Jan 10, 2011 at 1:56 PM, James Morris <jmorris@namei.org> wrote:
> >
> > In these cases it's my local 'master', which is tracking your tree.  I'll
> > look at renaming that or creating a new branch called linus-master.
> 
> That doesn't much help. It now says the source, but still gives no
> indication _why_ you pulled.
> 
> If you want to sync up, use a tag or something. Then it actually makes
> sense, and a merge message like "Merge tag 'v2.6.36-rc7'" actually
> makes sense.
> 
> But "Merge branch 'linus-master'" just makes me (and anybody else) go
> "why did the security tree merge some random daily thing"?

The most common cases are to resolve a conflict, or to apply a patch which 
depends on something in your tree, neither of which are really directly 
associated with tags.


- James
-- 
James Morris
<jmorris@namei.org>
