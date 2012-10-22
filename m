Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab2JVJF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 05:05:56 -0400
Received: from antcom.de ([188.40.178.216]:39285 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907Ab2JVJFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 05:05:55 -0400
Message-ID: <50850C6D.1050300@antcom.de>
Date: Mon, 22 Oct 2012 11:05:49 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com
Subject: Re: [PATCH RFC 02/15 v5] gpio: Add sysfs support to block GPIO API
References: <1350477107-26512-1-git-send-email-stigge@antcom.de> <1350477107-26512-3-git-send-email-stigge@antcom.de> <20121017190520.GC25996@kroah.com> <507FD4EB.1080204@antcom.de> <CACRpkda35jKs9YVNDAo96=0QzdMi+jkvJAzM=nX+HCK-d5+e9Q@mail.gmail.com> <50813EB0.9040102@antcom.de> <CACRpkdagQhUjdbda55JaY-J33MTNsEMMFJ=1je8V428ZkEMb9A@mail.gmail.com>
In-Reply-To: <CACRpkdagQhUjdbda55JaY-J33MTNsEMMFJ=1je8V428ZkEMb9A@mail.gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 10:55 AM, Linus Walleij wrote:
> On Fri, Oct 19, 2012 at 1:51 PM, Roland Stigge <stigge@antcom.de> wrote:
>> So what do you think about my just proposed idea of always having the
>> "value" argument present, but only useable when "exported" is "1"? Now
>> only talking about the block gpios, but later maybe also for gpios?
> 
> We should atleast be consistent and do it the same way for
> blocks as individual gpios.

OK, I'll leave it as creating-attribute-on-export.

>> But I would only do this if you and Greg consider it reasonable.
> 
> I'm still afraid of this whole thing and would seek Grant's consent.

Yes, he acked. :-)

Thanks,

Roland
