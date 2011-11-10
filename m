Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933296Ab1KJTyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 14:54:19 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:47354 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751151Ab1KJTyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 14:54:17 -0500
X-Sasl-enc: llyqgDmyVu8mc8GwIfEsgZuzE9QTrCibvR9rPjdO9bRi 1320954856
Date: Thu, 10 Nov 2011 11:54:11 -0800
From: Greg KH <greg@kroah.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: "George G. Davis" <gdavis@mvista.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org,
        jason.wessel@windriver.com, Andi Kleen <andi@firstfloor.org>,
        lwn@lwn.net
Subject: Re: Announcement: Plans for v2.6.34-longterm
Message-ID: <20111110195411.GA11357@kroah.com>
References: <20101203210719.GB21223@windriver.com>
 <ADA45A9A-E9A4-4B4C-80FF-711340F931BB@mvista.com>
 <4EB9B731.9040804@windriver.com>
 <20111108235256.GB9866@kroah.com>
 <20111109032036.GF1354@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111109032036.GF1354@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 10:20:37PM -0500, Paul Gortmaker wrote:
> [Re: Announcement: Plans for v2.6.34-longterm] On 08/11/2011 (Tue 15:52) Greg KH wrote:
> 
> [...]
> 
> > Also, I would like to populate the linux-stable.git tree with the
> > missing .34-longterm releases that you have already done, care to
> > provide a git tree that I can pull from for those now?
> 
> Hi Greg,
> 
> The below pull rq should get your repo caught up on the .34
> content for my tags 8 --> 10.  You should be able to use the
> "git verify-tag v2.6.34.10" on this older content without issue
> as a double check on things.

$ git verify-tag v2.6.34.10
gpg: Signature made Sun 26 Jun 2011 09:47:42 AM PDT using DSA key ID 0D0A18AD
gpg: Good signature from "Paul Gortmaker (work) <paul.gortmaker@windriver.com>"
gpg: Note: This key has expired!
Primary key fingerprint: 2A15 067C 2C4D F8FD A89E  1882 DBE2 2294 0D0A 18AD

So I know that this was signed with an exprired key that is only
self-signed, hm, looks like that matches up with the previous releases
form you :)

thanks, now pushed out.

Hopefully you have a new key, that is in the kernel.org ring of trust,
that you will be using to sign your new releases?

thanks,

greg k-h
