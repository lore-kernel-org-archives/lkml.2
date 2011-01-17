Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab1AQR2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 12:28:06 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52470 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab1AQR2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 12:28:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=pNFDZTyoMCOG8jZb0qLpcnHJSiRN3YmQOI5mxGRARa3dwxtlYR88w9BSUL8ec6/UTX
         sGVZrPbCTtLcdnELcFG0Z8x8seNqq46j07lO05Itea2jl8gUYfgl4oafsYTqMAH09DyF
         CvOPjUxoWNKkHRVbSzn691dErXg/Z1aVlTHAE=
Date: Mon, 17 Jan 2011 15:27:47 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf-record: auto detect when stdout is a pipe
Message-ID: <20110117172747.GD2085@ghostprotocols.net>
References: <m3ipxo966i.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3ipxo966i.fsf@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Jan 16, 2011 at 05:14:45PM +0100, Franck Bui-Huu escreveu:
> From: Franck Bui-Huu <fbuihuu@gmail.com>
> 
> This patch gives the ability to perf-record to detect when its stdout
> has been redirected to a pipe. There's now no more need to add '-o -'
> switch in this case.
> 
> However '-o <path>' option has always precedence, that is if specified
> and stdout has been connected via a pipe then the output will go into
> the specified output.
> 

I guess we could have that in perf report as well? I.e. if stdin is a
FIFO...

Thanks, applied,

- Arnaldo
