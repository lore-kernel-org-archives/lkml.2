Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab0E2IjK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 04:39:10 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:36097 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab0E2IjG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 04:39:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OR+FZYnax5Q11mWpAoexk0H/MyXWrTwlYN36wvwgjmjn4o2DSubuc/dPQpEdebYgNp
         b8M37G55AQ32NFNbbSQDewQ2I7JF/A+fPAMAe1kxjL0EczD6I/X9PwuW0rXclJJj4Z59
         tISSxuhVZgBSs0BSQ3nyoPEvlWvIIZ9FL/PLU=
MIME-Version: 1.0
In-Reply-To: <20100528132138.2d802d77@lxorguk.ukuu.org.uk>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>
	<20100527230806.4deb6de3@lxorguk.ukuu.org.uk>
	<20100527220949.GB10602@srcf.ucam.org>
	<20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	<AANLkTil6Bo7qZltbLzHJjIDyruKHFQEURpe5LPJEpTws@mail.gmail.com>
	<20100528101755.7b5f6b8a@lxorguk.ukuu.org.uk>
	<AANLkTilYHKKmQePBGW3LVLjUZy7HXHQku2Iub-LWGBm6@mail.gmail.com>
	<20100528132138.2d802d77@lxorguk.ukuu.org.uk>
Date: Sat, 29 May 2010 10:39:02 +0200
Message-ID: <AANLkTil-BYnf3swXPj_Llm-XpTks9-NKEi8fgq07JFV3@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Vitaly Wool <vitalywool@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Mailing List <linux-omap@vger.kernel.org>,
       Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, Linux@smtp1.linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>, Peter@smtp1.linux-foundation.org,
       Linux PM <linux-pm@lists.linux-foundation.org>, felipe.balbi@nokia.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/28 Alan Cox <alan@lxorguk.ukuu.org.uk>:
> Ok lets try and produce something more concrete. The control groups may
> be the wrong tool but we've got several such tools already
>
>
> Kernel involved
> ----------------
> acquire:                mark myself important (into cgroup important)
> acquire(timeout)        ditto, plus app timer/timeout handler
> release:                mark myself unimportant (into cgroup downtrodden)

May we somehow live without acquire(timeout)? This is the feature that
can screw up a lot of things with very complicated debugging options.

~Vitaly
