Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab1HJSAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 14:00:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43722 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754409Ab1HJSA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 14:00:29 -0400
Message-ID: <4E42C575.1040408@zytor.com>
Date: Wed, 10 Aug 2011 12:52:53 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: emmanuel.deloget@efixo.com
CC: David Woodhouse <dwmw2@infradead.org>, Arnaud Lacombe <lacombar@gmail.com>,
        Michal Marek <mmarek@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH 2/2] Enable 'make CONFIG_FOO=y oldconfig'
References: <1312067499.22074.59.camel@i7.infradead.org>	 <1312067670.22074.61.camel@i7.infradead.org>	 <CACqU3MV460WGjmQdOOmhk3ZJT1FNjEjfuHqx8mYcgun9+7SfjA@mail.gmail.com>	 <4E34998D.8060806@zytor.com>	 <CACqU3MWn-OQVfLH96E+AeTCEjUw5+girXbuNgmUvXrEQuBe4vg@mail.gmail.com>	 <4E4140B3.7090802@suse.cz>	 <CACqU3MU4wJb3ij6skod-ZiM+Q0OMTXNdbJ+qWjJW8VZNEP+x1g@mail.gmail.com>	 <4E4280BA.9050109@suse.cz> <1312981658.2989.39.camel@i7.infradead.org>	 <CACqU3MUJkM3Y2o2Jx1eQxZkW2T-Dby1JCaks6SqTz_FB17hSvw@mail.gmail.com>	 <1312985888.2989.46.camel@i7.infradead.org>	 <CACqU3MXozgu0kr-4w=bGejcEi8MrxH-PhKa0Ji0zrLu7ZEFomg@mail.gmail.com> <1312993987.2989.53.camel@i7.infradead.org> <4E42B940.6070904@efixo.com>
In-Reply-To: <4E42B940.6070904@efixo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2011 12:00 PM, Emmanuel Deloget wrote:
> 
> I understand that my question is indeed neither wanted nor clever, but 
> what's the point of trying to support "make CONFIG_FOO=y"?
> 
> Will we be expected to type a 42 meters long command line to compile the 
> kernel instead of doing a menuconfig in the foreseable future? (and 
> between typos, unmet dependencies and the myriad of other possible 
> errors, I'm not sure I'll get more free time).
> 
> I don't get it. If the goal is to help the kernel hackers and if it 
> really helps them it might be a thing to do - it might prove useful for 
> very simple CONFIG_ options but I'm not sure this will stay true for the 
> general case.
> 

That's useful for some cases, though, instead of having to create a
file; the driving cases here are architecture, platform or 32/64-bit
selection.  For longer ones you'll create a file.

And no, menuconfig and .config files will not go away.

	-hpa
