Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab2AaCfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 21:35:30 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35572 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab2AaCf3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 21:35:29 -0500
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB307C8C0@HASMSX103.ger.corp.intel.com>
References: <CAHFgRy-1519kkWwBxfe8UZMcOHqrbiq34dTX-wN5a+pd_4GPSA@mail.gmail.com>
	<5D69FF551B764E40A8245E579F3F73E602114ABC@ORSMSX102.amr.corp.intel.com>
	<0BA3FCBA62E2DC44AF3030971E174FB307C8C0@HASMSX103.ger.corp.intel.com>
Date: Mon, 30 Jan 2012 21:35:27 -0500
Message-ID: <CAHFgRy-4bJdShGSRe4ijcjREgtwcWvAa-EhOfhGFSrCwUL=7Tg@mail.gmail.com>
Subject: Re: 3.3.0-rc1+ (Linus GIT) - iwlwifi losing connection regularly.
From: Miles Lane <miles.lane@gmail.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 3:38 PM, Grumbach, Emmanuel
<emmanuel.grumbach@intel.com> wrote:
> Hi Miles,
>
> Thanks for the detailed bug description.
>
>>
>> I find that with builds of Linus GIT over the last week or so I need
>> to rmmod and insmod the iwlwifi driver about once every ten minutes.
>> When the connection stops working, networkmanager still shows the
>> connection as active, but no data is getting through (Web, pings,
>> etc).
>> I enabled full debug output and here is a sample of kern.log that
>> stretches from a point in time when the connection was working through
>> past when it failed.
>> Please let me know if I can help debug this further.  I don't have
>> time to do a bisection, unfortunately.
>>
>
> Quite a few people reported an issue that I think can be solved by the patch attached.
> Would you mind try and report ?
> Thanks
> ---------------------------------------------------------------------
> Intel Israel (74) Limited

Thanks!  This patch works great for me.  It did not apply cleanly to
the latest GIT pull from the Linus' tree:

# patch -p1 < ~/Downloads/tid.patch
patching file drivers/net/wireless/iwlwifi/iwl-agn-tx.c
patching file drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
Hunk #1 succeeded at 1261 (offset -290 lines).
