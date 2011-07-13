Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab1GMAz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 20:55:57 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:36496 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753267Ab1GMAzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 20:55:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=doxb0tJ6BpqDEh7aiRqhXvlnlad1IcLb0Y1e7T8okTkNqhM8u0rxyHnfiMlYoelemBjyI2DPUmiQhr3bWAucp7/XLgp3Qj/a1BlUXbDaXWNKlXZIVbPD8GnC/w19pTH8;
Date: Tue, 12 Jul 2011 17:55:52 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Valdis.Kletnieks@vt.edu
Cc: Pekka Enberg <penberg@kernel.org>, Jesper Juhl <jj@chaosbits.net>,
        Arnaud Lacombe <lacombar@gmail.com>,
        =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Raghavendra D Prabhu <rprabhu@wnohang.net>,
        linux-kbuild@vger.kernel.org, Nir Tzachar <nir.tzachar@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Avoid Wunused-but-set warning
Message-Id: <20110712175552.965870c3.rdunlap@xenotime.net>
In-Reply-To: <32171.1310517312@turing-police.cc.vt.edu>
References: <da20dc5c4160ed9a3da52f60799a1e4369fe3f27.1310228130.git.rprabhu@wnohang.net>
	<CAM_iQpXeqc01dyHpViyJCMSz6wz-1mWmGi=J0UynUG8tbd99kw@mail.gmail.com>
	<CACqU3MUgVTpc6kBvBiw7rtyn_JTA-JPrbnvai3Vnq+UWk-jSbQ@mail.gmail.com>
	<CAOJsxLF+4VOXJwRJL7npMngDTGztXk739_GcMLxsMzmsVcDCVw@mail.gmail.com>
	<CACqU3MUFO9DGqnK99ApaKn00vzj5rCB5=kjuSZGZpPU8c_4G-A@mail.gmail.com>
	<20110710110241.7650e03f.rdunlap@xenotime.net>
	<alpine.LNX.2.00.1107110051420.2818@swampdragon.chaosbits.net>
	<20110710160722.ae763029.rdunlap@xenotime.net>
	<alpine.LNX.2.00.1107110117080.2818@swampdragon.chaosbits.net>
	<CAOJsxLHzXV3MDHH+83iwxaUtO=931Bmq1JRzS=MQx=6wa-wi2w@mail.gmail.com>
	<32171.1310517312@turing-police.cc.vt.edu>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jul 2011 20:35:12 -0400 Valdis.Kletnieks@vt.edu wrote:

> On Mon, 11 Jul 2011 08:55:19 +0300, Pekka Enberg said:
> 
> > The definitions in SubmittingPatches are not hard rules and are, in
> > fact, out of date. See Documentation/development-process/5.Posting for
> > alternative definitions:
> > 
> >  - Acked-by: indicates an agreement by another developer (often a
> >    maintainer of the relevant code) that the patch is appropriate for
> >    inclusion into the kernel.
> > 
> > and
> > 
> >  - Reviewed-by: the named developer has reviewed the patch for correctness;
> >    see the reviewer's statement in Documentation/SubmittingPatches for more
> >    detail.
> 
> Unfortunately, SubmittingPatches says:
> 
>         By offering my Reviewed-by: tag, I state that:
> 
>          (a) I have carried out a technical review of this patch to
>              evaluate its appropriateness and readiness for inclusion into
>              the mainline kernel.
> 
>          (b) Any problems, concerns, or questions relating to the patch
>              have been communicated back to the submitter.  I am satisfied
>              with the submitter's response to my comments.
> 
>          (c) While there may be things that could be improved with this
>              submission, I believe that it is, at this time, (1) a
>              worthwhile modification to the kernel, and (2) free of known
>              issues which would argue against its inclusion.
> 
>          (d) While I have reviewed the patch and believe it to be sound, I
>              do not (unless explicitly stated elsewhere) make any
>              warranties or guarantees that it will achieve its stated
>              purpose or function properly in any given situation.
> 
> and often, I'm only comfortable stating (b) - often, I'd like to *disavow* both
> (a) and (c)(1) - I usually *don't* do a tech review, and may have no opinion as
> to whether it's "cooked" enough to be included.  Also, usually, the only "known
> issue" from (c)(2) is the one thing I commented on for part (b)...
> 
> Comments-Addressed-Acked: anybody? :)

then you just want to use Acked-by instead of Reviewed-by.  I think.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
