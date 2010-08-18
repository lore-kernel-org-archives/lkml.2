Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab0HRO1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 10:27:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49278 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab0HRO1w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 10:27:52 -0400
Subject: Re: [PATCH] perf tools: Fix build error on read only source.
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Kusanagi Kouichi <slash@ac.auone-net.jp>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100818141611.GE9410@ghostprotocols.net>
References: <20100817181835.GA21083@ghostprotocols.net>
	 <20100818123713.1F02414C03B@msa103.auone-net.jp>
	 <1282135224.1926.3936.camel@laptop>
	 <20100818141611.GE9410@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 18 Aug 2010 16:27:45 +0200
Message-ID: <1282141665.1926.4053.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-18 at 11:16 -0300, Arnaldo Carvalho de Melo wrote:
> rm -rf ~/build
> make O=~/build
> 
> and have everything work? Saving some keystrokes 8)

The turn side is that if you typo the output dir you'll probably not
ever find it again.. and you could have typed: rm -rf ~/build/* instead.


