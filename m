Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab0LUVKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 16:10:21 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:57083 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab0LUVKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 16:10:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=Preixk2T2bvHAqn1lYN3w4A+mQAdrK6E9pMQjpzUcXFYjTRSYZT/nU0RWfU/61QtDI
         TObsXlqpbnLcfEnwFxcevwjYa6PWttl7L8BdXB+8Y7XJHcZ68eyYL5VKHCSDxF/APsY1
         aNRzE3XyD4xpGn4khUJT6qw1ls9/NUwWTG4ak=
Date: Tue, 21 Dec 2010 19:05:02 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH 0/6] Minor cleanups & fixes for perf-probe(1)
Message-ID: <20101221210502.GA29079@ghostprotocols.net>
References: <1292854685-8230-1-git-send-email-fbuihuu@gmail.com>
 <4D10A795.9040809@hitachi.com>
 <m3aajzc8f1.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3aajzc8f1.fsf@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 21, 2010 at 07:01:06PM +0100, Franck Bui-Huu escreveu:
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> writes:
> > (2010/12/20 23:17), Franck Bui-Huu wrote:
> >> This small patchset is just some random cosmetic cleanups I did when
> >> starting to read perf-probe(1) stuffs.

> > Basically the contains of this series are good to me.  (I've sent my
> > comments) however, it's less comments on each patch. Please explain
> > what you did in each patch! (not only on the subject line:-))

> Ok. I thought those changes in this serie was obvious enough.
> 
> > Thank you,
> 
> You're welcome.

I did just that s/fprintf/color_fprintf/g change Masami asked and
stashed everything in my perf/core branch.

Thanks,

- Arnaldo
