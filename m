Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab1AZTuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 14:50:22 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46325 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab1AZTuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 14:50:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=r3j4E/E5FEmLz7e6h3Fp2kB09sp762fp3nlksiYAb+brDgMVQTV8juVrf5fcaqcYrY
         O2mhcU1UN9i9nndPH7w4mDt892J4V+sTrYDDBomOTxWfSnndjcu0tVBkMuRdW0eCG81C
         /GNw8aM5bmDt3aY/OiJiCambkTLAKc8KO3pKg=
Date: Wed, 26 Jan 2011 11:50:12 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
Message-ID: <20110126195011.GF29268@core.coreip.homeip.net>
References: <20110125205453.GA19896@core.coreip.homeip.net>
 <4D3F4804.6070508@redhat.com>
 <4D3F4D11.9040302@teksavvy.com>
 <20110125232914.GA20130@core.coreip.homeip.net>
 <20110126020003.GA23085@core.coreip.homeip.net>
 <4D403855.4050706@teksavvy.com>
 <4D405A9D.4070607@redhat.com>
 <4D4076FD.6070207@teksavvy.com>
 <20110126194127.GE29268@core.coreip.homeip.net>
 <4D407A46.4080407@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D407A46.4080407@teksavvy.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 02:47:18PM -0500, Mark Lord wrote:
> On 11-01-26 02:41 PM, Dmitry Torokhov wrote:
> >
> > I do not consider lsinput refusing to work a regression.
> 
> Obviously, since you don't use that tool.
> Those of us who do use it see this as broken userspace compatibility.
> 
> Who the hell reviews this crap, anyway?
> Code like that should never have made it upstream in the first place.
> 

You are more than welcome spend more time on reviews.

Thanks.

-- 
Dmitry
