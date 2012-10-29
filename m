Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab2J2HlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 03:41:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60858 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab2J2HlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 03:41:14 -0400
Date: Mon, 29 Oct 2012 08:40:55 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [Q] .readable_reg() not verified during read?
In-Reply-To: <20121028180629.GB4547@opensource.wolfsonmicro.com>
Message-ID: <Pine.LNX.4.64.1210290833440.17869@axis700.grange>
References: <Pine.LNX.4.64.1210280034310.4378@axis700.grange>
 <20121028180629.GB4547@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:6LoxTQpsPNB/mgUyksBcZoyDVvYQnB5EAKTgaxRRXav
 DJYBUXqbDhdbNcYs2qp8V/smWEhVEr/SNVcfCyS87uMxO29TF/
 GApLGVD27/jelwRdGTP4gW3zDEvx4i7ZSmKBij/6fhPhUno+df
 D1PbdND8r2HjYnSq5mP3g2jRJWphARIzWOKCNvt+5FRkHEZNd5
 JfwIiZHndD5rQ6owYzxznl5xRqYBVj8jgJk9/ce8WcvuVu+uSf
 MDqR726gqgDMASdU57OzoxydjJ9HJNC4ZWCXjzNAJG+Icx9yaR
 61E2wBdbEzTsoDMUuprmzDcPTTYARFkI4Kg3233C9dyj89QdKJ
 WNch2an96OczLbDuD0r5bWewQiZPgr223+lDvBLcaM4aVF+tyH
 R2wOmV0baiCzQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2012, Mark Brown wrote:

> On Sun, Oct 28, 2012 at 12:36:40AM +0200, Guennadi Liakhovetski wrote:
> 
> > Looking at regmap.c it looks like the .readable_reg() callback is not 
> > consulted when performing a register read, e.g. in _regmap_raw_read(). Is 
> > this intentional? If yes - why?
> 
> No real reason, though to be honest it's not that important - the main
> reason for having the function is to make the debugfs stuff work nicely
> rather than anything else.

But what about initialising the register cache in regcache_hw_init()? 
Doesn't it read in all registers without checking their readability?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
