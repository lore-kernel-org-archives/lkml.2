Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab1KUN7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 08:59:48 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58106 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab1KUN7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 08:59:46 -0500
MIME-Version: 1.0
In-Reply-To: <20111121030640.GI32505@gamma.logic.tuwien.ac.at>
References: <20111102031345.GA10851@gamma.logic.tuwien.ac.at>
	<1320204101.31823.140.camel@wwguy-huron>
	<20111104045817.GA25778@gamma.logic.tuwien.ac.at>
	<20111107123812.GB23508@gamma.logic.tuwien.ac.at>
	<1320709047.31823.188.camel@wwguy-huron>
	<20111108043233.GA21171@gamma.logic.tuwien.ac.at>
	<CANUX_P0Q0wve4D6fZPsMv2Zw=02gb9u+3C2cjRv7UAmWqXnjzw@mail.gmail.com>
	<CANUX_P06ww42p6N1k_P-Y1KMKOd1QgR_DxVWe19qtsEX2rfWpw@mail.gmail.com>
	<20111109051152.GA16006@gamma.logic.tuwien.ac.at>
	<CANUX_P2Yz9bWP_EmU1Acs7Mu2w78CXxO-njhiMt97b0TJHFYiQ@mail.gmail.com>
	<20111121030640.GI32505@gamma.logic.tuwien.ac.at>
Date: Mon, 21 Nov 2011 15:59:44 +0200
Message-ID: <CANUX_P2AA5stHwjegKdFhFGg7jxwdVU2Xr8OUtXUdEOKz_6E5A@mail.gmail.com>
Subject: Re: iwlagn is getting very shaky
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Norbert Preining <preining@logic.at>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> And what I stil see is that the tx-queue gets stuck and does not
> recover without rmmod iwlwif.
>
> hwq 11: read=0 write=0 stop=1 swq_id=0x2e (ac 2/hwq 11)
>
> But I still am using the patch that you sent to disable power save,
> so it is not only this one.
>
> If you think I shouuld turn on power debug again and see hope that
> it happens again, let me know.

No, I don't think it is needed. Thanks.

I do would like you to check that you have my patch:

iwlwifi: add debug information on queue stop / wake

and run with debug flags 0x80000000 (bit 31)
This will print a message each time a queue is stopped / started.

Thanks for your patience !
