Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab3AGSok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 13:44:40 -0500
Received: from mout1.freenet.de ([195.4.92.91]:42841 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523Ab3AGSoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 13:44:38 -0500
Message-ID: <50EB16E3.9080504@01019freenet.de>
Date: Mon, 07 Jan 2013 19:41:39 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Firefox/17.0 SeaMonkey/2.14
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: Andreas Hartmann <andihartmann@01019freenet.de>,
        Ben Hutchings <ben@decadent.org.uk>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 104/173] rt2x00: Dont let mac80211 send a BAR when an AMPDU
 subframe fails
References: <20121228190352.097882544@decadent.org.uk> <50DEA41E.6010409@01019freenet.de> <1356871099.4821.16.camel@deadeye.wl.decadent.org.uk> <1356871357.4821.19.camel@deadeye.wl.decadent.org.uk> <20130107080532.GA2984@redhat.com> <20130107081003.GB2984@redhat.com> <1357568256.26822.18.camel@deadeye.wl.decadent.org.uk> <50EAE3E1.4010809@01019freenet.de> <CAGXE3d841+9yYMKUOGs3y9hib87m73QDMzDFDsSJrqe+xnqMHw@mail.gmail.com>
In-Reply-To: <CAGXE3d841+9yYMKUOGs3y9hib87m73QDMzDFDsSJrqe+xnqMHw@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Helmut!

Helmut Schaa wrote:
> On Mon, Jan 7, 2013 at 4:04 PM, Andreas Hartmann
> <andihartmann@01019freenet.de> wrote:
>> The solution would be IMHO, to implement an own aggregation handling,
>> maybe the same way as it was done for carl9170, which had the same problem:
>>
>> http://thread.gmane.org/gmane.linux.kernel.wireless.general/100793/focus=1405
>>
>> I prefer to have solutions (if one is known) instead of another workaround.
> 
> JFI, I'm just working on exactly that (handling BAR TX status in
> driver to implement proper RX reorder window flushing at the peer). I'll post it for
> further testing to the rt2x00 list once I'm done.

Thank you for your time spent on this problem! I really appreciate it!


Kind regards!
Andreas
