Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab2CMNkk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 09:40:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:39262 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab2CMNkj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 09:40:39 -0400
Message-ID: <1331646021.18960.71.camel@twins>
Subject: Re: [PATCH 4/4] perf report: Treat an argument as a symbol filter
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung.kim@lge.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 13 Mar 2012 14:40:21 +0100
In-Reply-To: <20120313062105.GB24357@elte.hu>
References: <1331619294-29162-1-git-send-email-namhyung.kim@lge.com>
	 <1331619294-29162-4-git-send-email-namhyung.kim@lge.com>
	 <20120313062105.GB24357@elte.hu>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-13 at 07:21 +0100, Ingo Molnar wrote:
> To play the devil's advocate it uses up valuable perf report 
> command line real estate and we probably cannot change this 
> workflow in the future, once people get used to it. 

I would indeed suggest to make it a proper argument and add argument
parsing to report like we have for all the other commands.

Say something like: perf report --symbol-filter="foobar"
and maybe an appropriate short version.
