Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649Ab1ELUZK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 16:25:10 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53292 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab1ELUZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 16:25:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rpYoMSODrb5B7ETmX4GFew8Szlp/Mvf80FqBeZ3AoQIVSiBZOVA4K+HEsHbI3dzwxh
         bbrQ9VFqWhyNCElUYuCzgYoosT2e2z6HajW6DxH8TlhWReYpVsYwsfqMIEAbF0LmUBgV
         Frbudn0gezOhKS86IOrvH2bIo72k0CZiRyoLs=
Date: Thu, 12 May 2011 23:24:21 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: davej@redhat.com, eranian@google.com, acme@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
Message-ID: <20110512202421.GA4623@p183>
References: <BANLkTim8mAzZbdOhBodaOFKM5esP-Q+K7g@mail.gmail.com>
 <20110512.140630.1779004012724490077.davem@davemloft.net>
 <20110512183741.GA22269@redhat.com>
 <20110512.150132.1679483014638599288.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512.150132.1679483014638599288.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 03:01:32PM -0400, David Miller wrote:
> From: Dave Jones <davej@redhat.com>
> Date: Thu, 12 May 2011 14:37:41 -0400
> 
> > On Thu, May 12, 2011 at 02:06:30PM -0400, David Miller wrote:
> >  > I hate this too, and I think it's absolutely rediculous.
> >  > 
> >  > Also, like you, I lost an entire afternoon trying to figure out why
> >  > this started happening.
> >  > 
> >  > I wish we could revert this change.
> > 
> > At least it can be permanently disabled..
> > 
> > echo kernel.kptr_restrict = 0 >> /etc/sysctl.conf
> 
> Regardless, what to do about all of the "perf is broken" reports?

The problem is that they turned it on by default.

	int kptr_restrict = 1;
