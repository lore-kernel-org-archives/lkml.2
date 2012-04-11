Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759977Ab2DKChy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 22:37:54 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:45778 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965Ab2DKChw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 22:37:52 -0400
Date: Wed, 11 Apr 2012 11:37:47 +0900
From: Norbert Preining <preining@logic.at>
To: Emmanuel Grumbach <egrumbach@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
        "ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: 3.4-rc2, ilwagn still most of the time completely unusable
Message-ID: <20120411023747.GA10126@gamma.logic.tuwien.ac.at>
References: <20120330011734.GH6277@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120330011734.GH6277@gamma.logic.tuwien.ac.at>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I am now having problems with the iwlagn driver since about 4 kernel
revisions, without any tendency that things are getting better.

I already have reported that with 3.3-wl there are hundreds and thousands
of lines
	delba from 00:0a:79:eb:56:10 (initiator) tid 0 reason code 39
	Rx BA session stop requested for ...
*IF* it is connected.

On the contrary, it sometimes not even connects, after reloading the module,
retrying many times, today my log was smarmed with messages:
	[ 9457.156030] wlan0: authentication with 00:24:c4:ab:bd:e0 timed out
	[ 9457.176828] iwlwifi 0000:06:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:24:c4:ab:bd:e0

Above is all on the University network, which is rather new and
in good shape.

But I want to report *SOME* progress: Formerly I had *BIG* problems 
with my home network (some strange Corega WL router AFAIR, Japanese only,
but it was working without a click before 2.6.38 or 39 or so).
Now, when I *DISABLE* 11n (11n_disable=1) then all the problems are
gone *AT*HOME*, no warnings anymore, no complains, no hickups.
On the university it is still a pain.

As I have already sent debug output etc etc as requested here, I will
not repeat that unless asked for it.

Well, hope that in another 20 kernel revisions that might get fixed,
we are not talking about a brand new wlan adapter anymore ... that
was some years ago ... especially the regression from 2.6.38 where it
was working without any problem to the current very sad state of affair
is frustrating.


On Fr, 30 Mär 2012, Norbert Preining wrote:
> I am now running 3.3.0-wl, and I was now travelling quite some time
> without having *any*problems with wlan. But as soon as I come
> home or to the university the horror starts. Here at home I am 
> now, after fresh reboot, no suspend involved, swamped with dmesg
> lines:
> [ 8206.158741] delba from 00:0a:79:eb:56:10 (initiator) tid 0 reason code 39
> [ 8206.158744] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
> [ 8206.430282] Rx A-MPDU request on tid 0 result 0
> 
> So around 4000+ in 2 hours ... I guess you can evaluate how flaky the
> connection is ...

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
GOLANT (adj.)
Blank, sly and faintly embarrassed. Pertaining to the expression seen
on the face of someone who has clearly forgotten your name.
			--- Douglas Adams, The Meaning of Liff
