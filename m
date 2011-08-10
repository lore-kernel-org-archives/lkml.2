Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab1HJOSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 10:18:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:52801 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab1HJOSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 10:18:11 -0400
Subject: Re: [PATCH 2/2] Enable 'make CONFIG_FOO=y oldconfig'
From: David Woodhouse <dwmw2@infradead.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Date: Wed, 10 Aug 2011 15:17:47 +0100
In-Reply-To: <CACqU3MUJkM3Y2o2Jx1eQxZkW2T-Dby1JCaks6SqTz_FB17hSvw@mail.gmail.com>
References: <1312067499.22074.59.camel@i7.infradead.org>
	 <1312067670.22074.61.camel@i7.infradead.org>
	 <CACqU3MV460WGjmQdOOmhk3ZJT1FNjEjfuHqx8mYcgun9+7SfjA@mail.gmail.com>
	 <4E34998D.8060806@zytor.com>
	 <CACqU3MWn-OQVfLH96E+AeTCEjUw5+girXbuNgmUvXrEQuBe4vg@mail.gmail.com>
	 <4E4140B3.7090802@suse.cz>
	 <CACqU3MU4wJb3ij6skod-ZiM+Q0OMTXNdbJ+qWjJW8VZNEP+x1g@mail.gmail.com>
	 <4E4280BA.9050109@suse.cz> <1312981658.2989.39.camel@i7.infradead.org>
	 <CACqU3MUJkM3Y2o2Jx1eQxZkW2T-Dby1JCaks6SqTz_FB17hSvw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312985888.2989.46.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-10 at 10:15 -0400, Arnaud Lacombe wrote:
> 
> hum, let's take a real life example: user foo wants his config to
> enable CONFIG_WIRELESS_EXT, so with what you propose, he would do:
> 
> # make CONFIG_WIRELESS_EXT=y allmodconfig
> 
> currently, this would _never_ work, unless one of the symbol selected
> by `allmodconfig' selects it, as WIRELESS_EXT is defined the
> following:
> 
> config WIRELESS_EXT
>     bool
> 
> I suspect there also an implicit dependency to WIRELESS. 

This is a complete red herring. It's *always* been like that, and works
*just* like this for the 'all.config' file etc.

If you have nothing relevant to say, just don't say anything.

-- 
dwmw2

