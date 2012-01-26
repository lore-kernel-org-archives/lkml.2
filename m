Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab2AZAhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 19:37:54 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:34213 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab2AZAhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 19:37:53 -0500
Date: Thu, 26 Jan 2012 09:37:35 +0900
From: Norbert Preining <preining@logic.at>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
        "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: Re: iwlagn is getting even worse with 3.3-rc1
Message-ID: <20120126003735.GA2346@gamma.logic.tuwien.ac.at>
References: <20120124013625.GB18436@gamma.logic.tuwien.ac.at> <CANUX_P3er0orBy8OhDuY1DfgD810UD-_HB_ukJnCA+W8e-VazQ@mail.gmail.com> <20120125002250.GA20431@gamma.logic.tuwien.ac.at> <CANUX_P0UREz_jZABu+Y_QYOh9tx_sKZSSkZpYHBEVtcU4QQdSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANUX_P0UREz_jZABu+Y_QYOh9tx_sKZSSkZpYHBEVtcU4QQdSA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Emmanuel,

On Di, 24 Jan 2012, Emmanuel Grumbach wrote:
> yeah... looks like the same issue as Dave. Can you please try with 0xc0000000 ?
> it will be noisy so be prepared...

syslog output is at http://www.logic.at/people/preining/syslog.log
this is after a suspend and resume.

first connection after resume succeeded at around kernel time 378.859794
then it worked for say 20sec or so, hard to say when exactely it dropped,
but defeinitely at kernel time 451 it was finished.

After that nothing went out or in again.

Hope you can make something out of that.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
SKETTY (n.)
Apparently self-propelled little dance a beer glass performs in its
own puddle.
			--- Douglas Adams, The Meaning of Liff
