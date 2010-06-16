Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023Ab0FPM0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 08:26:31 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:39208 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758724Ab0FPM03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 08:26:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wQG7nwtIBqjA2qUKtZzr0sasa3rpVsKpkzy0IMnphnerJS9e7PfSQPMv8LTuxebzHj
         QBOqqHDwwqaLkRpklgxZUmT7mdOqhp3/8Vb3LQ21lUrKkiCEpjw6BkH3IByCD/a4NjhH
         etm92PsVYo9IjhAPK5cHInwC1AfhaCg7h+9CM=
Date: Wed, 16 Jun 2010 16:26:19 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
       Russell King <rmk@arm.linux.org.uk>,
       Huang Weiyi <weiyi.huang@gmail.com>
Subject: Re: linux-next: manual merge of the battery tree with the
 arm-current tree
Message-ID: <20100616122619.GA22259@oksana.dev.rtsoft.ru>
References: <20100615125512.09c79d9b.sfr@canb.auug.org.au>
 <AANLkTilwnVs1970j0DkobtpyDKY8mOX9EX6iFP2uSvYR@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTilwnVs1970j0DkobtpyDKY8mOX9EX6iFP2uSvYR@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 02:54:58PM +0800, Eric Miao wrote:
> On Tue, Jun 15, 2010 at 10:55 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Hi Anton,
> >
> > Today's linux-next merge of the battery tree got a conflict in
> > drivers/power/z2_battery.c between commit
> > 56b925fccc58cd43fc553a8302dbbdd440aef288 ("[ARM] pxa/z2: fix missing
> > include in battery driver") from the arm-current tree and commit
> > 5d111107b7994349feb681466f873b1a4f8a09d6 ("z2_battery: Remove duplicated
> > #include") from the battery tree.
> >
> > The former is a superset of the latter.
> 
> Marek has submitted a revised patch which goes into the -pxa tree
> due to dependency of z2_battery and some of the pxa machine files.
> 
> Anton,
> 
> Any suggestion? Or if you feel OK for this to go through the -pxa tree, I'd
> like to have your Ack.

Sure thing,

Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>

Meanwhile, I dropped the "z2_battery: Remove duplicated #include"
patch from battery-2.6.git.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
