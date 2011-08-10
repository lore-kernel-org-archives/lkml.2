Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab1HJQdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 12:33:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:46379 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab1HJQdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 12:33:11 -0400
Subject: Re: [PATCH 2/2] Enable 'make CONFIG_FOO=y oldconfig'
From: David Woodhouse <dwmw2@infradead.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Date: Wed, 10 Aug 2011 17:33:05 +0100
In-Reply-To: <CACqU3MXozgu0kr-4w=bGejcEi8MrxH-PhKa0Ji0zrLu7ZEFomg@mail.gmail.com>
References: <1312067499.22074.59.camel@i7.infradead.org>
	 <1312067670.22074.61.camel@i7.infradead.org>
	 <CACqU3MV460WGjmQdOOmhk3ZJT1FNjEjfuHqx8mYcgun9+7SfjA@mail.gmail.com>
	 <4E34998D.8060806@zytor.com>
	 <CACqU3MWn-OQVfLH96E+AeTCEjUw5+girXbuNgmUvXrEQuBe4vg@mail.gmail.com>
	 <4E4140B3.7090802@suse.cz>
	 <CACqU3MU4wJb3ij6skod-ZiM+Q0OMTXNdbJ+qWjJW8VZNEP+x1g@mail.gmail.com>
	 <4E4280BA.9050109@suse.cz> <1312981658.2989.39.camel@i7.infradead.org>
	 <CACqU3MUJkM3Y2o2Jx1eQxZkW2T-Dby1JCaks6SqTz_FB17hSvw@mail.gmail.com>
	 <1312985888.2989.46.camel@i7.infradead.org>
	 <CACqU3MXozgu0kr-4w=bGejcEi8MrxH-PhKa0Ji0zrLu7ZEFomg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312993987.2989.53.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-10 at 10:34 -0400, Arnaud Lacombe wrote:
> your point being ? I might as well tell you that I find the current
> behavior of 'all*.config' just as broken wrt. to dependency
> management.

You might indeed. And I would find that commentary just as irrelevant
and unhelpful.

> > If you have nothing relevant to say, just don't say anything.
> >
> maybe you can come with a detailed description of your proposal's
> behavior, including how to manage case like this, instead of just
> throwing patch around ?

How's this for a definition:

"The behaviour for unsettable (or unclearable) options shall be exactly
like it already is if you put them in all*.config, or if you manually
edit the .config file and run 'make oldconfig', as people have been
doing for years. There is nothing new to see here."
 
> If I do:
> 
> # make CONFIG_WIRELESS_EXT=y allnoconfig
> 
> I expect either a success or an error, not a silent discard. And
> *yes*, the problem already exists with "all*.config".

[dwmw2@i7 linux-2.6]$ make CONFIG_WIRELESS_EXT=y allnoconfig
scripts/kconfig/conf --allnoconfig Kconfig
#
# Could not set CONFIG_WIRELESS_EXT=y; perhaps it has unmet dependencies?
#
#
# configuration written to .config
#

-- 
dwmw2

