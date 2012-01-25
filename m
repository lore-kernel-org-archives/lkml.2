Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab2AYFcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 00:32:48 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55193 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab2AYFcq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 00:32:46 -0500
MIME-Version: 1.0
In-Reply-To: <20120125002250.GA20431@gamma.logic.tuwien.ac.at>
References: <20120124013625.GB18436@gamma.logic.tuwien.ac.at>
	<CANUX_P3er0orBy8OhDuY1DfgD810UD-_HB_ukJnCA+W8e-VazQ@mail.gmail.com>
	<20120125002250.GA20431@gamma.logic.tuwien.ac.at>
Date: Tue, 24 Jan 2012 21:32:45 -0800
Message-ID: <CANUX_P0UREz_jZABu+Y_QYOh9tx_sKZSSkZpYHBEVtcU4QQdSA@mail.gmail.com>
Subject: Re: iwlagn is getting even worse with 3.3-rc1
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
        "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 16:22, Norbert Preining <preining@logic.at> wrote:
> Hi Emmanuel,
>
> On Mo, 23 Jan 2012, Emmanuel Grumbach wrote:
>> Can you please run with debug flags 0x80000000 ?
>
> Here we go. Booting into 3.3-rc1 tries to connect, the connection seems
> to be established, but nothing actually goes out/in.
> Main problem seems to be:
>        iwlagn_tx_agg_stop Can't proceed: ssn 340, next_recl = 329
>
> rfkill block wifi ; sleep 10; rfkill unblock wifi
>
> helps.
>
> I attach the dmesg of all wifi related things since boot.
>

yeah... looks like the same issue as Dave. Can you please try with 0xc0000000 ?
it will be noisy so be prepared...

I will send a patch to clarify one thing about mgmt frames, but as I
said I am not in my office until end of next week.
