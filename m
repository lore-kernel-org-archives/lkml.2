Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab1DMGoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 02:44:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48817 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab1DMGoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 02:44:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oi7KkVp5cVIVC0XHOUGqJiSHam/5OZmR3s2ms4S2O6eM4zC51VNGUx7CDPtyPvaerQ
         ocDNLXeIrhOursrkx9aNm3vIrTTkXw0atWuXzqWTrQyfV7r0UfqF7Fg3xHaRqj0Urpsz
         T0nKCJ4ukBysrBLWJBwD3WjxdNGHXTifdTLo0=
Date: Wed, 13 Apr 2011 09:44:32 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: mm: convert vma->vm_flags to 64bit
Message-ID: <20110413064432.GA4098@p183>
References: <BANLkTinLdWB+ON=TY=KHyzsrC8gC5bXg7Q@mail.gmail.com>
 <1302646024.28876.52.camel@pasglop>
 <20110413091301.41E1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110413091301.41E1.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 09:13:03AM +0900, KOSAKI Motohiro wrote:
> > On Tue, 2011-04-12 at 14:06 +0300, Alexey Dobriyan wrote:
> > > On Tue, Apr 12, 2011 at 10:12 AM, KOSAKI Motohiro
> > > <kosaki.motohiro@jp.fujitsu.com> wrote:
> > > > After next year? All developers don't have to ignore compiler warnings!
> > > 
> > > At least add vm_flags_t which is sparse-checked, just like we do with gfp_t.
> > > 
> > > VM_SAO is ppc64 only, so it could be moved into high part,
> > > freeing 1 bit?
> > 
> > My original series did use a type, I don't know what that was dropped,
> > it made conversion easier imho.
> 
> Yes, I take Hugh's version because vm_flags_t is ugly to me. And arch 
> dependent variable size is problematic.

Who said it should have arch-dependent size?
