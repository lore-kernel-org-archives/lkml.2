Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab1DDAMC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 20:12:02 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:57066 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab1DDAMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 20:12:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XnJlT8EP1H/Qtv6RkL5/UJGQDVRml1TsDay915viu7lWVPzNu/W6QXxj1khrUNm0c+
         iteOkucUniXPVZAJPhTPHVJdsr5jUSB1jPC41M+v/ZKd7+WZuOEczSbaqwF8HbCABleD
         XdHnzV6nerPie/PEETtZVhO0/uQCl7s0drEmg=
Date: Sun, 3 Apr 2011 17:11:54 -0700
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, roland@hack.frob.com
Subject: Re: [PATCH 0/4] Was: signal, ptrace: Fix delayed CONTINUED
 notification when ptraced
Message-ID: <20110404001154.GD1420@mtj.dyndns.org>
References: <20110329144603.GA29865@htj.dyndns.org>
 <20110329144648.GB29865@htj.dyndns.org>
 <20110329144710.GC29865@htj.dyndns.org>
 <20110330192918.GA14861@redhat.com>
 <20110331072942.GB3385@htj.dyndns.org>
 <20110331151549.GA8458@redhat.com>
 <20110331163441.GF3385@htj.dyndns.org>
 <20110331172946.GA14934@redhat.com>
 <20110401181123.GA9010@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110401181123.GA9010@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 08:11:23PM +0200, Oleg Nesterov wrote:
> On 03/31, Oleg Nesterov wrote:
> >
> > > I'll mull over it a bit more but please go ahead and create a proper
> > > patch.
> >
> > Yes, will do tomorrow (and it needs the trivial re-diff against your tree).
> 
> OK, please consider this series for your tree.
> 
> 4/3 is a bit off-topic, but imho makes sense right now.

Applied 1-4 to misc:ptrace.  Thanks Oleg.

-- 
tejun
