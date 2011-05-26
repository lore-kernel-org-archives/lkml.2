Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267Ab1EZSoC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:44:02 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46854 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757756Ab1EZSoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:44:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=V+5+rAbh1rrGtxt3luTyb1DL7sZNreu5YORhw/LHfE+loW/T4rLCxe8htc0aL6qDUZ
         cWQNp32DmIOj7URLdC/gchkZXW603ZyCY3M2qRHEfhDGonxadyg+8JWYyaPT1S/NxCIV
         qDf8Ke15ppPMbx8XiXi/OV05Y5vW19GcUY61g=
Date: Thu, 26 May 2011 21:44:02 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, benh@kernel.crashing.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, hughd@google.com,
        akpm@linux-foundation.org, dave@linux.vnet.ibm.com,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH] mm: don't access vm_flags as 'int'
Message-ID: <20110526184402.GA2453@p183.telecom.by>
References: <4DDE2873.7060409@jp.fujitsu.com>
 <BANLkTi=znC18PAbpDfeVO+=Pat_EeXddjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=znC18PAbpDfeVO+=Pat_EeXddjw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 10:53:34AM -0700, Linus Torvalds wrote:
> 2011/5/26 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>:
> > The type of vma->vm_flags is 'unsigned long'. Neither 'int' nor
> > 'unsigned int'. This patch fixes such misuse.
> 
> I applied this, except I also just made the executive decision to
> replace things with "vm_flags_t" after all.

Woo-hoo!

Why it is marked __nocast and not __bitwise__ like gfp_t?
