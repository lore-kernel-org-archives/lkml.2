Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab2LDMFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 07:05:04 -0500
Received: from plane.gmane.org ([80.91.229.3]:51067 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab2LDMFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 07:05:00 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Hassan Salehe Matar <hmatar@ku.edu.tr>
Subject: Re: perf user tool precise attribute broken in 3.5rc1+
Date: Tue, 4 Dec 2012 12:02:02 +0000 (UTC)
Message-ID: <loom.20121204T125921-269@post.gmane.org>
References: <20120607202355.GQ27374@one.firstfloor.org> <CABPqkBQ99PTsET6c_NPuioLUr_yto4x=6EBQ1K73N4ratHz48A@mail.gmail.com> <20120607205836.GT27374@one.firstfloor.org> <20120607212759.GD30641@infradead.org> <20120608031009.GV27374@one.firstfloor.org> <20120608154814.GA21250@infradead.org> <20120608165319.GC27374@one.firstfloor.org> <20120608215549.GF27374@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 212.175.32.139 (Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:17.0) Gecko/20100101 Firefox/17.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi <at> firstfloor.org> writes:

> 
> 
> Hmm, the problem disappeared after a make clean. 
> Sorry for the noise.
> 
> -Andi
> 
Andi, I am using your hsw_pmu 3.6 kernel and the perf it comes with. However, I
experience the same problem you addressed here. Could you elaborate how you
solved the problem by "make clean"?

-Hassan



