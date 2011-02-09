Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab1BIJ4D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 04:56:03 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51418 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab1BIJ4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 04:56:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nLHY9Oc2fAccDJNImA6+x7tmeoDI7Ir5hjdMJllx2VD16HubOOUpkclUZ2DiX42pnB
         Xku/+HRcsnRRN6r0YEfzhKNUS5hW4pkiCkx6/C2/o/wbVVfTurS0ZzvtinR4pXV0ix4V
         PwXI08siPS6Y9WwTh7qzVAsvpFqZOHu8P+vLU=
Date: Wed, 9 Feb 2011 10:55:56 +0100
From: Tejun Heo <tj@kernel.org>
To: Chris Clayton <chris2553@googlemail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, simon@fire.lp0.eu,
        kay.sievers@vrfy.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: 2.6.38-rc2+ - regresiion copying DVD's
Message-ID: <20110209095556.GD3770@htj.dyndns.org>
References: <201101301550.59272.chris2553@googlemail.com>
 <201101311929.05290.chris2553@googlemail.com>
 <201102062312.14919.chris2553@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102062312.14919.chris2553@googlemail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 06, 2011 at 11:12:14PM +0000, Chris Clayton wrote:
> Hi again,
> 
> On Monday 31 January 2011, Chris Clayton wrote:
> > On Sunday 30 January 2011, Chris Clayton wrote:
> > > Hi,
> > >
> > > Firstly, I'm not subscribed, so please cc me on any reply.
> > >
> > > I'm trying to copy the3 contents of a video DVD from one disc to another,
> > > but it fails. There are no messages in the kernel log file, but K3B
> > > reports the following:
> >
> > <snip>
> >
> > Simon's patch at http://marc.info/?l=linux-kernel&m=129649842110692&w=4
> > fixes this problem, so feel free to add
> >
> > Tested-by: Chris Clayton <chris2553@googlemail.com>
> >
> I note that Simon's patch hasn't made it through to Linus yet. Which tree is ot 
> going through, please?

Block tree.  Jens?

-- 
tejun
