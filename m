Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233Ab0LHUgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 15:36:09 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:42109 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab0LHUgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 15:36:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=fb9LnMZOPqokrruEPNwNCX6GWcmUcUSwhqeBe3mfMXcT7CBxYaialU7gaF4vQVLPh9
         T4yMXeC12aU76qtEYLDPubhsKsny8uwhpkT/4/Dc7A+H776PHFzj+zWY/NNZB1dodn+x
         AXq4Q2NO5dc+KGPaL2qXJu6uwqr00A4UVSTdE=
Date: Wed, 8 Dec 2010 18:35:57 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <daahern@cisco.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf report: Allow user to specify path to kallsyms file
Message-ID: <20101208203557.GC10353@ghostprotocols.net>
References: <1291775986-16475-1-git-send-email-daahern@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291775986-16475-1-git-send-email-daahern@cisco.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 07, 2010 at 07:39:46PM -0700, David Ahern escreveu:
> This is useful for analyzing a perf data file on a different system
> than the one data was collected on and still include symbols from
> loaded kernel modules in the output.

Applied and also added the relevant entry to
tools/perf/Documentation/perf-report.txt, please do that next time you
add some new command line option.

- Arnaldo
