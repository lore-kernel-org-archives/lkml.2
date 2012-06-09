Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab2FIQrz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 12:47:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994Ab2FIQry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 12:47:54 -0400
Date: Sat, 9 Jun 2012 13:47:42 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Stephane Eranian <eranian@google.com>, jolsa@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: perf user tool precise attribute broken in 3.5rc1+
Message-ID: <20120609164742.GD21250@infradead.org>
References: <20120607202355.GQ27374@one.firstfloor.org>
 <CABPqkBQ99PTsET6c_NPuioLUr_yto4x=6EBQ1K73N4ratHz48A@mail.gmail.com>
 <20120607205836.GT27374@one.firstfloor.org>
 <20120607212759.GD30641@infradead.org>
 <20120608031009.GV27374@one.firstfloor.org>
 <20120608154814.GA21250@infradead.org>
 <20120608165319.GC27374@one.firstfloor.org>
 <20120608215549.GF27374@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120608215549.GF27374@one.firstfloor.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jun 08, 2012 at 11:55:49PM +0200, Andi Kleen escreveu:
> Hmm, the problem disappeared after a make clean. 
> Sorry for the noise.

Thanks for the feedback!

- Arnaldo
