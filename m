Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab0HWOiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 10:38:50 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33564 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab0HWOir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 10:38:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=lWL1bDQ9lTknJm2UUKFKiXGHBDPLBGFcN18VQZ4BE8Mz9meQssrEI7g4Asm6m59pqs
         eFZ3qtzE25aCWBnXwTpD2m1vOww4Md0GNjzK4O6eD9R1wgdxTcgXNLgrQAPU92qaLWi+
         4AzXjPp+dha34ZR2Lbsoe2xtae5sczZnSPvtQ=
Date: Mon, 23 Aug 2010 11:38:39 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu
Subject: Re: [PATCH] perf tools: Fix linking errors with --as-needed flag
Message-ID: <20100823143839.GA2761@ghostprotocols.net>
References: <1279449937-29115-1-git-send-email-ozan@pardus.org.tr>
 <4C42DFC0.1090708@pardus.org.tr>
 <20100821172433.GF2973@ghostprotocols.net>
 <1282459432.11398.53.camel@tropicana>
 <1282531453.30047.8.camel@tropicana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282531453.30047.8.camel@tropicana>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Aug 22, 2010 at 09:44:13PM -0500, Tom Zanussi escreveu:
> Looking into it a bit further, both ExtUtils::Embed -e ldopts and
> python-config --ldflags put the libs at the end, so we should be able to
> parse the output of those and take only the parts we need for each
> component.  How about something like this instead?

Ozan, Kirill, can you please test Tom's patch and see if it fixes the
problems you noticed so that I can add Tested-by tags and apply this
patch?

Thanks,

- Arnaldo
