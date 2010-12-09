Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab0LIJZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 04:25:14 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34290 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab0LIJZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 04:25:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FeI/wJDTOvMWCABZq7PD8cmlSk9b7Q9aLH+NGWatoCsZS4CKI7NJdTKSJGAtlKXaQA
         cE/Yeoiwt4Tu/6DtikDXcogEzLdA0sLYNrhISLzwvRKk0Q+BtAYWjrwJWNWiAfRPp3oO
         Gdgtc7RuIFi7m7FfTl2f8bktH7ufTJuCpEWjs=
Date: Thu, 9 Dec 2010 01:25:02 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ping Cheng <pingc@wacom.com>,
        Chris Bagwell <chris@cnpbagwell.com>
Subject: Re: [RFC][PATCH] input: Introduce device information ioctl
Message-ID: <20101209092502.GC8821@core.coreip.homeip.net>
References: <1291706726-8835-1-git-send-email-rydberg@euromail.se>
 <20101207091653.GA22416@core.coreip.homeip.net>
 <4CFE919A.1040704@euromail.se>
 <20101208060200.GD4140@core.coreip.homeip.net>
 <4CFFD6D2.5060703@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CFFD6D2.5060703@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 08:04:50PM +0100, Henrik Rydberg wrote:
> > One concern is that while 32 distinct device types should be enough
> 
> > should we plan for larger capability array? Should we use variable
> > length ioctl - like EVIOCGKEY(len) - even though Arnd does not like
> > them?
> 
> 
> Sounds good, but then again the struct approach feels quite extensible too...
> 

Actually the more I think about it the less I like idea of extending the
struct because while keeping ABI is pretty easy there are other issues.

I'll CC you on EVIOCGKEYCODE patch so you can see my concerns.

-- 
Dmitry
