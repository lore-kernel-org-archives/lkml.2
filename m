Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab3AGOaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 09:30:10 -0500
Received: from jdl.com ([208.123.74.7]:38636 "EHLO jdl.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754510Ab3AGOaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 09:30:08 -0500
Message-Id: <E1TsDiF-0001dJ-0g@jdl.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
cc: David Gibson <david@gibson.dropbear.id.au>, Matt Porter <mporter@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Russ Dill <Russ.Dill@ti.com>
Subject: Re: Fix test relying in wrong behavior of is_printable
In-reply-to: <6BBCA320-AB8C-4DE3-BF98-3A77B1E94982@antoniou-consulting.com>
References: <1357326968-13124-1-git-send-email-panto@antoniou-consulting.com> <20130106035809.GG4674@truffula.fritz.box> <5B13DF52-26BE-4BA1-8BD7-25863B04A3B6@antoniou-consulting.com> <E1TryU3-0001K5-Iy@jdl.com> <6BBCA320-AB8C-4DE3-BF98-3A77B1E94982@antoniou-consulting.com>
Comments: In-reply-to Pantelis Antoniou <panto@antoniou-consulting.com>
   message dated "Mon, 07 Jan 2013 11:55:32 +0200."
Date: Mon, 07 Jan 2013 08:30:03 -0600
From: Jon Loeliger <jdl@jdl.com>
X-Spam-Score: 0.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Err,
> 
> I can rework and resubmit to remove the comment, but the test doesn't =
> fail:
> 
> > $ make check | grep 'MyBoardName.*-t s.*compatible'
> > fdtget-runtest.sh MyBoardName MyBoardFamilyName -t s label01.dts.fdtget.test.dtb / compatible:	PASS
> >
> 
> As of today's pull.

My build yields:

    $ make check 2>&1 | grep FAIL
    fdtget-runtest.sh 77 121 66 111 97 114 100 78 97 109 101 0 77 121 66 111 97 114 100 70 97 109 105 108 121 78 97 109 101 0 label01.dts.fdtget.test.dtb / compatible: FAIL Results differ from expected
    *                FAIL:	1

HTH,
jdl
