Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab2B0MrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 07:47:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:59754 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab2B0MrG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 07:47:06 -0500
Message-ID: <1330346810.11248.70.camel@twins>
Subject: Re: [PATCH] hw breakpoint: Fix possible memory leak
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 27 Feb 2012 13:46:50 +0100
In-Reply-To: <1330346742.1782.7.camel@leonhard>
References: <1330311739-24302-1-git-send-email-namhyung.kim@lge.com>
	 <1330338785.11248.49.camel@twins> <20120227104452.GA6082@elte.hu>
	 <1330340694.11248.64.camel@twins> <1330346742.1782.7.camel@leonhard>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-27 at 21:45 +0900, Namhyung Kim wrote:
> This would depend on the initial value of the percpu memory

that should be all 0s iirc.
