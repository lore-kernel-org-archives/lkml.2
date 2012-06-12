Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab2FLAC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 20:02:59 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55317 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab2FLAC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 20:02:58 -0400
Date: Mon, 11 Jun 2012 21:02:53 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Andi Kleen <ak@linux.intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: Does perf inject preserve call chain data?
Message-ID: <20120612000253.GB3897@infradead.org>
References: <4FBC0C10.8010801@gmail.com>
 <20120608143843.GA9954@infradead.org>
 <1339173896.3796.230.camel@schen9-DESK>
 <4FD232B7.7080905@gmail.com>
 <1339175828.3796.232.camel@schen9-DESK>
 <20120608195215.GO28225@tassilo.jf.intel.com>
 <20120609160547.GB9954@infradead.org>
 <4FD63C52.4090003@linux.intel.com>
 <20120611215912.GA3897@infradead.org>
 <4FD66D17.3000202@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD66D17.3000202@linux.intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jun 11, 2012 at 03:11:35PM -0700, Andi Kleen escreveu:
> >http://git.kernel.org/?p=linux/kernel/git/acme/linux.git;a=commit;h=a78e5b82e99d8d284afc012ef015ef3332153aaf
> 
> Thanks. That would work I suppose.  I think I would still prefer a single
> command over a bunch of options, but having options is not too bad.

Not a bunch, just one option.

And only if you feel like, at that point in time, to snapshot it to send
it over e-mail.

- Arnaldo
