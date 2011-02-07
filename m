Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab1BGMbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 07:31:12 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61425 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab1BGMbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 07:31:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=wp+7kqXJ39FRSez3Mu+sf6oU0CzR36/ONgixko5LkiCRLO/9RT/GQEUO6uBEVTilIH
         H/TMTOQPtl8FNxWOWt4F8jfRLmq4H9e+/xffUs8pIhmA3jVjeZfeTc7kUUmFmy2Xg2Nr
         rMKbHL6sSv4qnJbataQHPB0n9xaBSalFcHwow=
Date: Mon, 7 Feb 2011 10:31:06 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Franck Bui-Huu <vagabon.xyz@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH] perf-probe: rewrite find_lazy_match_lines() by using
 getline(3)
Message-ID: <20110207123106.GA4470@ghostprotocols.net>
References: <m3d3o185u1.fsf@gmail.com>
 <4D2ED322.4040508@hitachi.com>
 <4D4FBC2B.5000108@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D4FBC2B.5000108@hitachi.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Feb 07, 2011 at 06:32:27PM +0900, Masami Hiramatsu escreveu:
> Hi Arnaldo,
> 
> Could you merge this patch into your perf/core tree?
> This makes code very simple and easy to read :-)

Right, will process these and others you sent before returning to work
on the live TUI annotation in perf top :)

- Arnaldo
