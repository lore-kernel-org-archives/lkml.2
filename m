Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab1JNOkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 10:40:08 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:45725 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246Ab1JNOkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 10:40:06 -0400
Date: Fri, 14 Oct 2011 10:39:55 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/21] pci: drop unused Kconfig symbol
Message-ID: <20111014143954.GA12349@phenom.oracle.com>
References: <1318595439.6132.77.camel@x61.thuisdomein>
 <20111014135743.GD4577@phenom.oracle.com>
 <1318601485.6132.91.camel@x61.thuisdomein>
 <1318602126.6132.99.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318602126.6132.99.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet23.oracle.com [156.151.31.71]
X-CT-RefId: str=0001.0A090206.4E9849C4.00E9,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 04:22:06PM +0200, Paul Bolle wrote:
> On Fri, 2011-10-14 at 16:11 +0200, Paul Bolle wrote:
> > Perhaps this driver is (some part of) xen. That I didn't check. Should I
> > have done that too?
> 
> Obviously, since this symbol in unused now, it's not possible to
> determine what driver is involved. That would be different if this
> Kconfig symbol was actually used previously. But I didn't check - for

Huh? You can look at what it depends and track that down.

> all those symbols involved in this series - why they turned out to be
> unused now. So I can't say whether these symbols should never have been
> in the tree in the first place or whether they were forgotten when
> someone removed their last actual usage.

I am so confused. So lets start with the foremost question I have:

How did you determine that they were unusued?
