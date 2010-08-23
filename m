Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab0HWQH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 12:07:28 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36919 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab0HWQHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 12:07:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=hiDFaQtM2wugttbKFm/TypUHxr/W4vE7nmd9vgBo7ZFRWV/xu6Q7HNPLw4VuueLz6W
         kTNo1IWpq3SlM5ayqjWsy7x4nIj8jvH1yjZwpVef3LBPgk3bwN6nVP2Gbk1bGgo775Za
         5xj0we78GhCC4+iTa7jYnsYebXit00gUMpMsg=
MIME-Version: 1.0
In-Reply-To: <AANLkTim-M6dfLvJQnbieFqZCGG33E+-i+u_soCq2p9f1@mail.gmail.com>
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com>
	<1282144271.3035.31.camel@mulgrave.site>
	<AANLkTinRDMXqyDAVkcbioD=L7XO-47KHL2qjR+8KA5m3@mail.gmail.com>
	<1282148296.3035.49.camel@mulgrave.site>
	<4C6C1D70.7020502@vlnb.net>
	<41A1E2691BBB412BADCDE5F515CD8EDA@usish.com.cn>
	<8A96806D-6CD7-44AD-8A9D-143C098C95A4@uni-paderborn.de>
	<1282256949.30453.278.camel@haakon2.linux-iscsi.org>
	<4C701E08.2020005@vlnb.net>
	<1282423398.3015.39.camel@mulgrave.site>
	<AANLkTikcReFsYMhs1RkCHoRkL1+Q9WuptHj1xbx49YsA@mail.gmail.com>
	<1282508953.3042.102.camel@mulgrave.site>
	<4C727BEB.9020100@scalableinformatics.com>
	<AANLkTim-M6dfLvJQnbieFqZCGG33E+-i+u_soCq2p9f1@mail.gmail.com>
Date: Mon, 23 Aug 2010 12:07:23 -0400
Message-ID: <AANLkTinDY8hEABHaPsCC+3wGMCn0ZLcyfDa9U9jXJ3d4@mail.gmail.com>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
From: Chetan Loke <chetanloke@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: landman@scalableinformatics.com, James Bottomley <James.Bottomley@suse.de>,
        Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        scst-devel <scst-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 11:11 AM, Bart Van Assche <bvanassche@acm.org> wrote:

>
> There is an important design difference between SCST and LIO: SCST by
> defaults creates multiple threads to process the I/O operations for a
> storage target, while LIO only creates a single thread per storage target.
> This makes SCST perform measurably faster.
>

Forget that. You could have discussed this if there were code reviews
or other mainline inclusion emails from James B. From what I have
heard, the decision was taken around 8-9 months back.
Would anyone like to either comment/validate/refute this please?  If
not then I would kindly request these guys to stop taking us for a
test drive. And also I'm not sure when was the last time James B.
bench-marked our scsi-stack. Even if I ACK in the xmit-path then I
can't push more than 100K IOPs. But other folks have re-engineered our
linux-scsi stack and from what I've heard they can push > 300K+ IOPs.
So I would just ignore performance discussion because I don't think
folks have done even simple lame experiments in the last 1 year. Or
may be I'm completely wrong and so please enlighten me so that I can
re-run the tests.


> Bart.
>
Chetan Loke
