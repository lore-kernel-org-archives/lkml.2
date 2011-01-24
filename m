Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab1AXNK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 08:10:56 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39143 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab1AXNKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 08:10:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=TdvaR+qBFAIiPMj4qSy35g/ihkIFIEwTbUWRDIHXgaMvKpmIwNyvAR6zUUYbOYc9+R
         eQG4aZ35nW7hvlce/oD9SczIzH9YXW6UofIpxK9YD9XSOx9mCASBcEbDdZBO+pwubEST
         Ub6aTr0+bVA26m9AiT32aTsXdAAk9A90PXG5M=
Date: Mon, 24 Jan 2011 11:10:50 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Michal Sojka <sojkam1@fel.cvut.cz>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] perf: Document default event for perf record
Message-ID: <20110124131050.GA6367@ghostprotocols.net>
References: <1295695127-29309-1-git-send-email-sojkam1@fel.cvut.cz>
 <20110124130540.GD5932@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110124130540.GD5932@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 24, 2011 at 11:05:40AM -0200, Arnaldo Carvalho de Melo escreveu:
> Em Sat, Jan 22, 2011 at 12:18:37PM +0100, Michal Sojka escreveu:
> > The description of -e option was reformatted (unindented and enclosed
> > in an OpenBlock) in order to render the added line correctly.
> 
> Thanks, applying to perf/core.

Erm, can you please provide your Signed-off-by as requested in:

Documentation/SubmittingPatches

?

Thanks a lot,

- Arnaldo
