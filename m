Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab3AEItq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 03:49:46 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:43755 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab3AEItm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 03:49:42 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <43EB3AB3EEFE8D43B525F4D2EAF507E107F4160E@SCYBEXDAG04.amd.com>
References: <CA+icZUUCB3K1=DuM6Nonu+Qc+qg3cM_ODk9TDZ-uYCfLVOhrdw@mail.gmail.com>
	<CA+icZUXrQ4aq+cKXj3qEwnhtTGPBfHcJ6q_zTm3xSBUUh9W8dQ@mail.gmail.com>
	<CA+icZUVBdsAa7ZA7e_UNpBsAOpVOXcawhUncbHNdkC-MGY4qLw@mail.gmail.com>
	<43EB3AB3EEFE8D43B525F4D2EAF507E107F4160E@SCYBEXDAG04.amd.com>
Date: Sat, 5 Jan 2013 09:49:41 +0100
Message-ID: <CA+icZUWKSGzziU4Lbs2C=TM0zvGr9acW7=1aNmVEAF+e1EwLAA@mail.gmail.com>
Subject: Re: [3.8-{rc1,rc2}] ata1.00: failed to get Identify Device Data,
 Emask 0x1
From: Sedat Dilek <sedat.dilek@gmail.com>
To: "Huang, Shane" <Shane.Huang@amd.com>
Cc: Jeff Garzik <jgarzik@pobox.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Aaron Lu <aaron.lu@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 5, 2013 at 3:20 AM, Huang, Shane <Shane.Huang@amd.com> wrote:
>> OK, I see the patch I mentioned to fix the problem was later reverted [1].
>> The real fix is "libata: replace sata_settings with devslp_timing" [2].
>
> Yes, please use [2] which can also be found in kernel bugzilla #51881
> and is pending on Jeff's acceptance. Sorry for the trouble to you guys.
>
> Thanks,
> Shane

"Shane shane shane on you"... (that song text was different) :-).

- Sedat -

[1] http://www.youtube.com/watch?v=6J9iSpA9QTs
