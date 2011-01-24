Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab1AXNFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 08:05:46 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:53425 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab1AXNFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 08:05:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=viR6j4yYER/LorZM2EpMyFiCj2dwFXm07rly1CzZ3UnIAvd66rqfKjkPcw9b03pCZO
         3y1RxIU1wMUksYUtZ2TowimpvnRZhcfgI2K88A8fGWCubOxsfKvmkltJLrEjut3o0ZmD
         TJaSIFt2ACDccEnWrfkM/D7VxNgXgLRP/2QuI=
Date: Mon, 24 Jan 2011 11:05:40 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Michal Sojka <sojkam1@fel.cvut.cz>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] perf: Document default event for perf record
Message-ID: <20110124130540.GD5932@ghostprotocols.net>
References: <1295695127-29309-1-git-send-email-sojkam1@fel.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295695127-29309-1-git-send-email-sojkam1@fel.cvut.cz>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Jan 22, 2011 at 12:18:37PM +0100, Michal Sojka escreveu:
> The description of -e option was reformatted (unindented and enclosed
> in an OpenBlock) in order to render the added line correctly.

Thanks, applying to perf/core.

- Arnaldo
