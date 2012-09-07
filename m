Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278Ab2IGQOH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:14:07 -0400
Received: from inx.pm.waw.pl ([195.116.170.130]:42824 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746Ab2IGQOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:14:03 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.4.10 N_GSM tty_io WARNING and lockup
References: <m3k3w8g2m4.fsf@t19.piap.pl>
	<20120906140137.75ebe6ba@pyramind.ukuu.org.uk>
	<m3627qt7kn.fsf@t19.piap.pl> <m3sjauc7kh.fsf@intrepid.localdomain>
	<20120907142931.22c4ec5b@pyramind.ukuu.org.uk>
Date: Fri, 07 Sep 2012 18:14:00 +0200
In-Reply-To: <20120907142931.22c4ec5b@pyramind.ukuu.org.uk> (Alan Cox's
	message of "Fri, 7 Sep 2012 14:29:31 +0100")
Message-ID: <m3txv9n73r.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> BTW I'm not sure if it's a known bug: I closed the /dev/ttyS0 with
>> /dev/gsmmuxX still open, and then tried to set N_TTY ldisc on the
>> master device. It didn't work so well :-(
>
> That should be fixed in 3.7. It's unfixable until the lock splitting work
> is merged.

I see. Thanks.
-- 
Krzysztof Halasa
