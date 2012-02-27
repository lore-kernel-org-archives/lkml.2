Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab2B0Mum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 07:50:42 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41067 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab2B0Mul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 07:50:41 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of namhyung@gmail.com designates 10.68.212.232 as permitted sender) smtp.mail=namhyung@gmail.com; dkim=pass header.i=namhyung@gmail.com
Subject: Re: [PATCH] hw breakpoint: Fix possible memory leak
From: Namhyung Kim <namhyung@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1330346810.11248.70.camel@twins>
References: <1330311739-24302-1-git-send-email-namhyung.kim@lge.com>
	 <1330338785.11248.49.camel@twins> <20120227104452.GA6082@elte.hu>
	 <1330340694.11248.64.camel@twins> <1330346742.1782.7.camel@leonhard>
	 <1330346810.11248.70.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Feb 2012 21:50:34 +0900
Message-ID: <1330347034.1782.9.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-02-27 (Mon), 13:46 +0100, Peter Zijlstra wrote:
> On Mon, 2012-02-27 at 21:45 +0900, Namhyung Kim wrote:
> > This would depend on the initial value of the percpu memory
> 
> that should be all 0s iirc.

Yep, that's why I said there's no problem here.


-- 
Regards,
Namhyung Kim


