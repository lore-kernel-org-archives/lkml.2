Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab2GZPtx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:49:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35839 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab2GZPtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:49:52 -0400
MIME-Version: 1.0
In-Reply-To: <20120726124346.GF30717@aftab.osrc.amd.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
	<1343149213-10160-14-git-send-email-ming.lei@canonical.com>
	<20120726124346.GF30717@aftab.osrc.amd.com>
Date: Thu, 26 Jul 2012 23:49:50 +0800
Message-ID: <CACVXFVPfbwYTnkAiGn5DOsrd59OFgyHawKYRpR=LH3iQBDS=eA@mail.gmail.com>
Subject: Re: [RFC PATCH 13/13] driver core: firmware loader: cache devices
 firmware during suspend/resume cycle
From: Ming Lei <ming.lei@canonical.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 8:43 PM, Borislav Petkov <bp@amd64.org> wrote:
>> +#else
>> +static int fw_pm_notify(struct notifier_block *notify_block,
>> +                                     unsigned long mode, void *unused)
>> +{}
>
> static inline int fw_pm...

Will add inline in -v1.


Thanks,
--
Ming Lei
