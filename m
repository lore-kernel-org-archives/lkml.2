Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab2A0Kk2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 05:40:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:58008 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab2A0Kk1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 05:40:27 -0500
Message-ID: <1327660811.2446.155.camel@twins>
Subject: Re: Shift by one instruction in the perf annotate output
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?ISO-8859-1?Q?L=E9na=EFc?= Huard <lenaic@lhuard.fr.eu.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Date: Fri, 27 Jan 2012 11:40:11 +0100
In-Reply-To: <20120127102741.GA31782@elte.hu>
References: <201201270001.27765.lenaic@lhuard.fr.eu.org>
	 <1327652120.2446.123.camel@twins> <20120127102741.GA31782@elte.hu>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-27 at 11:27 +0100, Ingo Molnar wrote:
> On Core2 CPUs there's PEBS so 'p' will work, but there's no LBR 
> so the IP-rewinding does not work. 

Not on his thing.. PEBS is a trainwreck on model 15.
