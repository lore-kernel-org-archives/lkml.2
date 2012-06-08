Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964969Ab2FHVz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 17:55:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57169 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934536Ab2FHVzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 17:55:55 -0400
Date: Fri, 8 Jun 2012 23:55:49 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>, jolsa@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: perf user tool precise attribute broken in 3.5rc1+
Message-ID: <20120608215549.GF27374@one.firstfloor.org>
References: <20120607202355.GQ27374@one.firstfloor.org> <CABPqkBQ99PTsET6c_NPuioLUr_yto4x=6EBQ1K73N4ratHz48A@mail.gmail.com> <20120607205836.GT27374@one.firstfloor.org> <20120607212759.GD30641@infradead.org> <20120608031009.GV27374@one.firstfloor.org> <20120608154814.GA21250@infradead.org> <20120608165319.GC27374@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120608165319.GC27374@one.firstfloor.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hmm, the problem disappeared after a make clean. 
Sorry for the noise.

-Andi
