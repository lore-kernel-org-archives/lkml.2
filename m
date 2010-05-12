Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab0ELSLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 14:11:44 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:63488 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab0ELSLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 14:11:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=K7P6EQdbbUwAbXLT99t61XxCHfqw2STQ369sX47V5AeNYVskahlNmTJFCFVy6e/aSK
         8Ly7ZAMbLeAwiIvPHQL5FaB7k+Youw145bPJ0XIzcaKAzbxgrsaKFDKVYSL2oXaUioxS
         FpS2QXNKOAfeade6/Goqhdpn+bENxGg5xhfbk=
Date: Wed, 12 May 2010 11:11:21 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, npiggin@suse.de,
       marc@tensilica.com, jw@emlix.com, cl@linux.com, penberg@cs.helsinki.fi,
       mpm@selenic.com, akpm@linux-foundation.org, os@emlix.com,
       Michael.Hennerich@analog.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, dg@emlix.com, osw@emlix.com,
       rientjes@google.com, dbrownell@users.sourceforge.net,
       grant.likely@secretlab.ca, chris@zankel.net, Piet.Delaney@tensilica.com
Subject: Re: [LKML] Re: [PATCH v3] ad7877: keep dma rx buffers in seperate
 cache lines
Message-ID: <20100512181121.GA29366@core.coreip.homeip.net>
References: <20100512030350.GJ15903@laptop>
 <20100512122323J.fujita.tomonori@lab.ntt.co.jp>
 <AANLkTine8JmtsUo3_z6Cwdgm3LINCkJ9jL21r9eQWRm8@mail.gmail.com>
 <20100512142904Z.fujita.tomonori@lab.ntt.co.jp>
 <AANLkTinztzZMBaSG4sTqPXw4qNjmkK6gI1KOYIDIOVVx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinztzZMBaSG4sTqPXw4qNjmkK6gI1KOYIDIOVVx@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 10:37:05AM -0400, Mike Frysinger wrote:
> On Wed, May 12, 2010 at 01:28, FUJITA Tomonori wrote:
> > I guess that it would be better to start a new thread about this issue.
> 
> will do

In the mean time I will be applying the version of the patch with
___cacheline_aligned and buffers at the end, 'k?

-- 
Dmitry
