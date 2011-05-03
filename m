Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678Ab1ECAqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 20:46:07 -0400
Received: from mail-px0-f170.google.com ([209.85.212.170]:60458 "EHLO
	mail-px0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab1ECAqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 20:46:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=DB4nlMWhfVr4bPFe/Gg3dMTfss28C58SEbD+JjR5SKvpQUhTczm8saxzcviPMh0UB3
         MIUNxCA0qn3AGVOmANZN1zOhhRHNXHo9NAubtvIeldcqw3q+2MPCmzp7KmbaWoeSDbbj
         ZYruBSO2RjCi25MLfyk3b2NdWqfh3E8eE2ZDU=
Date: Tue, 3 May 2011 08:45:46 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: greg@kroah.com, joe@perches.com, akpm@linux-foundation.org,
        trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Oops 2/2]The frame size of xxx bytes is larger than 1024 bytes
Message-ID: <20110503004543.GA2266@gmail.com>
Mail-Followup-To: Randy Dunlap <randy.dunlap@oracle.com>, greg@kroah.com,
	joe@perches.com, akpm@linux-foundation.org, trivial@kernel.org,
	linux-kernel@vger.kernel.org
References: <20110430062222.GB4274@gmail.com>
 <20110502093244.7594a929.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502093244.7594a929.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 09:32:44AM -0700, Randy Dunlap wrote:
> On Sat, 30 Apr 2011 14:22:24 +0800 Harry Wei wrote:
> 
> > Hi us,
> > 	A warning disturbs me for a long time.
> > It shows like following.
> > 
> > [...]
> > Warning: the frame size of xxx bytes is larger than 1024 bytes.
> > [...]
> > 
> > See http://s1202.photobucket.com/albums/bb364/harrywei/Kernel/?action=view&current=report_bug1.png for details.
> > 	Of course, i wanna fix it. But i have no ways.
> > Can anyone do me a favor?
> 
> Hi Harry,
> 
> It looks like drivers/staging/rt28[67]0/ has all been removed, so no need to fix
> these warnings.  However, there are other frame size warnings still in the kernel
> tree if you want to fix them.
Hmmm..., it's true. I will try my best to do them.
> 
> Also it would be better just to insert the warnings in your email instead of
> posting a photo of them.
Okay, i will ;)


Thanks.
Harry Wei.


