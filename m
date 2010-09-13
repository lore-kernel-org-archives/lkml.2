Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab0IMRus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 13:50:48 -0400
Received: from mbox2.netikka.net ([213.250.81.203]:43695 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab0IMRur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 13:50:47 -0400
Message-ID: <4C8E6476.8010302@mandriva.org>
Date: Mon, 13 Sep 2010 20:50:46 +0300
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; sv-SE; rv:1.9.2.9) Gecko/20100825 Thunderbird/3.1.3
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: "stable@kernel.org" <stable@kernel.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [33-stable regression ssb/broadcom]
References: <4C8E6192.2010003@mandriva.org> <20100913174207.GA14092@suse.de>
In-Reply-To: <20100913174207.GA14092@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH skrev 13.9.2010 20:42:
> On Mon, Sep 13, 2010 at 08:38:26PM +0300, Thomas Backlund wrote:
>> In Mandriva 2010.1 we noticed that 2.6.33.7 broke ssb/Broadcom lan
>> for several users...
>
> Did you try the later releases which should have fixed this issue?
>

Well, 33.7 is the latest 2.6.33-stable kernel, wich MDV 2010.1 got based 
on, and it wont change to anything > 2.6.33.x

We'll have to issue a new kernel with that one reverted, but as I noted 
on the 2.6.34 regression thread, you dont like "broken trees out there",
so I decided to report it even if it's "out of support".

--
Thomas
