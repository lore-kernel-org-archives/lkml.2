Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab2AZVNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 16:13:10 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53862 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab2AZVNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 16:13:07 -0500
MIME-Version: 1.0
In-Reply-To: <CANUX_P0H_WaWwnpjoBcMpZQY4xH=cbVhAKxWKXmz-HwFMcWS6w@mail.gmail.com>
References: <20120124013625.GB18436@gamma.logic.tuwien.ac.at>
	<CANUX_P3er0orBy8OhDuY1DfgD810UD-_HB_ukJnCA+W8e-VazQ@mail.gmail.com>
	<20120125002250.GA20431@gamma.logic.tuwien.ac.at>
	<CANUX_P0UREz_jZABu+Y_QYOh9tx_sKZSSkZpYHBEVtcU4QQdSA@mail.gmail.com>
	<20120126003735.GA2346@gamma.logic.tuwien.ac.at>
	<CANUX_P0H_WaWwnpjoBcMpZQY4xH=cbVhAKxWKXmz-HwFMcWS6w@mail.gmail.com>
Date: Thu, 26 Jan 2012 13:13:05 -0800
Message-ID: <CANUX_P3XSCsWUJ9M55qeaK-DuPEMXODFPJiNk+BgnHN-=WECqw@mail.gmail.com>
Subject: Re: iwlagn is getting even worse with 3.3-rc1
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
        "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Dave,

Can you please try to patch attached to this thread. You and Norbert
are suffering from the same issue. I am merging the mail threads here.

On Wed, Jan 25, 2012 at 21:49, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> Hi Norbert,
>
>>
>> syslog output is at http://www.logic.at/people/preining/syslog.log
>> this is after a suspend and resume.
>>
>> first connection after resume succeeded at around kernel time 378.859794
>> then it worked for say 20sec or so, hard to say when exactely it dropped,
>> but defeinitely at kernel time 451 it was finished.
>>
>> After that nothing went out or in again.
>>
>> Hope you can make something out of that.
>>
>
> Unfortunately, not really. I can see you are hitting PASSIVE_NO_RX,
> meaning that the uCode complains that you are trying to Tx on a
> passive channel on which it hasn't heard any beacon yet. But then we
> finally get a beacon there, and open the queue again.
>
> Anyway, can you try the attached patch ?
> Note that I have no real way to test it (I have to admit I haven't
> even compiled... I am not in my office).
> I hope it might help.
