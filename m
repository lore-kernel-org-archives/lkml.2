Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab2FTOo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 10:44:57 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:65121 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515Ab2FTOoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 10:44:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAHdPZaP7SekiCYcciYpcf7AGbRgRG7E8q97HvnCf0qRPQOA55A@mail.gmail.com>
References: <1338704660-30921-1-git-send-email-devendra.aaru@gmail.com>
	<e9129201-3636-49f6-9e97-156cb9823fd3@googlegroups.com>
	<CAHdPZaP7SekiCYcciYpcf7AGbRgRG7E8q97HvnCf0qRPQOA55A@mail.gmail.com>
Date: Wed, 20 Jun 2012 15:44:54 +0100
Message-ID: <CAOh2x=noV1bOzV7p7F6_iKjt2y1tcd1j5o2Ys0cuwC5+efLCHw@mail.gmail.com>
Subject: Re: [PATCH] rtc/rtc-spear: free the config right after the rtc_device_unregister
From: viresh kumar <viresh.linux@gmail.com>
To: "devendra.aaru" <devendra.aaru@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        rajeev <rajeev-dlh.kumar@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 3:39 PM, devendra.aaru <devendra.aaru@gmail.com> wrote:
> On Wed, Jun 20, 2012 at 7:57 PM, Viresh Kumar <viresh.linux@gmail.com> wrote:
>> Reviewed-by: Viresh Kumar <viresh.linux@gmail.com>
>
> Thanks, at last :-).
>
> Is there any tree through which it can reach torvalds?

The way I would have found this information about any driver is by
looking at its
git-log and check via which path patches have been going till date. Maintainers
normally adds there signed-off's to patches that go through them.

Andrew Morton, is the one who applied rtc-spear patches till now. Added in cc.

--
viresh
