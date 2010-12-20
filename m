Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504Ab0LTMx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 07:53:58 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65085 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab0LTMx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 07:53:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=rE72PUvqESfRmlZ4bTcv1QVFxWXyTcQaqi0laieUz+oj2fhVB3Pwm72ckcjJvmTkqe
         f0AXoiZj6suCtL49LF35ipPakP2CGM2m3QSV5kT2E1gf5G/mTPCfV7DkpX/TE57sSrse
         jm8HDmJZVIRFEiQT7RA5KGYgQ5SGdnOR3qkhE=
Date: Mon, 20 Dec 2010 10:53:52 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: Why not making tools/* git submodules ?
Message-ID: <20101220125352.GB26204@ghostprotocols.net>
References: <m27hf9crqa.fsf@gmail.com>
 <m2zks3w44z.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2zks3w44z.fsf@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Dec 18, 2010 at 03:24:12PM +0100, Francis Moreau escreveu:
> 
> Adding linux-perf-users mailing list, hoping that someone out there is
> more interested by this subject.
> 
> Francis Moreau <francis.moro@gmail.com> writes:
> 
> > Hello,
> >
> > I'm just wondering if all tools such as perf could be tracked using
> > git submodule.

I wasn't aware of "submodules", will read about it, thanks for bringing
this to our attention.

> > That would allow the tools to have their own tags at least.

yeah, that would be cool.

- Arnaldo
