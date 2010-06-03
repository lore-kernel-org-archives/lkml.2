Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933460Ab0FCJPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 05:15:55 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:57206 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933401Ab0FCJPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 05:15:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZpkFJ2KI4H1kToKtAhUayKiERmzwv4fk2o+102lCYJCvMROMxGwF9up9MxWP3sEmya
         GRaDyQgmNn7lq+7x8oHG3Wq2Gy4ZsZF3pWn7d6naBQyoGJGMTp4Lz9zA6VvLF8wHFZzX
         9Ib/kyKqvU8mamkofs9U12WccvPJO4xwdDAEQ=
Date: Thu, 3 Jun 2010 13:15:48 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Luming Yu <luming.yu@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc1 ahci regression
Message-ID: <20100603091548.GA23492@oksana.dev.rtsoft.ru>
References: <AANLkTikWak8i-Kaj-e-EUFWE66tfMmp2UPhGJCKkK1zK@mail.gmail.com>
 <20100603075402.GA11093@oksana.dev.rtsoft.ru>
 <AANLkTil6k_4YwdvLai_VUlVjgz030ctu7djVGHu0qgd2@mail.gmail.com>
 <20100603084104.GA17431@oksana.dev.rtsoft.ru>
 <AANLkTilSNOgD1HrvYBMEsza5-IIeBS1U7AHChO1vJKuf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTilSNOgD1HrvYBMEsza5-IIeBS1U7AHChO1vJKuf@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 04:56:54PM +0800, Luming Yu wrote:
> >
> > So, I wonder, have you actually bisected the thing correctly?
> 
> That is possible,
> 
> But git-bisecting just takes too much times even in any modern
> hardware with reasonable configurations
> 
> I  git-archive --format=tar  365cfa1ed5a36f9bcb9f64c9f0f52155af2e9fef
> tree and  then reverted the patch gotten from "git show
> 365cfa1ed5a36f9bcb9f64c9f0f52155af2e9fef"
> 
> then it boots,  otherwise not boot.

Hm. OK, can you please send boot log of a working kernel?

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
