Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab2BFK2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 05:28:51 -0500
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:55441 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752764Ab2BFK2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 05:28:51 -0500
X-Greylist: delayed 1211 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Feb 2012 05:28:51 EST
Message-Id: <4F3041500200002300007E56@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 06 Feb 2012 03:08:32 -0700
From: "Joey Lee" <jlee@suse.com>
To: <merlin.schumacher@gmail.com>
Cc: <ike.pan@canonical.com>, <mjg@redhat.com>, "Joey Lee" <JLee@suse.com>,
        <linux-kernel@vger.kernel.org>, <platform-driver-x86@vger.kernel.org>
Subject: Re: [PATCH] acer-wmi: support for P key on TM8372
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Merlin, 

於 四，2012-01-26 於 12:53 +0100，Merlin Schumacher 提到：
> Am 26.01.2012 03:28, schrieb joeyli:
> > Hi Ike,
> >
> > 於 二，2012-01-24 於 04:35 +0800，Ike Panhc 提到：
> >> From: Merlin Schumacher<merlin.schumacher@gmail.com>
> >>
> >> BugLink: http://launchpad.net/bugs/865807
> >>
> >> There is no entry for P key on TM8372, so when P key is pressed, only
> >> "acer_wmi: Unknown key number - 0x29" in dmesg.
> >>
> >> Signed-off-by: Merlin Schumacher<merlin.schumacher@gmail.com>
> >> Signed-off-by: Ike Panhc<ike.pan@canonical.com>
> >
> > Reviewed-by: Lee, Chun-Yi<jlee@suse.com>
> >
> >> ---
> >>   drivers/platform/x86/acer-wmi.c |    1 +
> >>   1 files changed, 1 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
> >> index b848277..d48262c 100644
> >> --- a/drivers/platform/x86/acer-wmi.c
> >> +++ b/drivers/platform/x86/acer-wmi.c
> >> @@ -105,6 +105,7 @@ static const struct key_entry acer_wmi_keymap[] = {
> >>   	{KE_KEY, 0x22, {KEY_PROG2} },    /* Arcade */
> >>   	{KE_KEY, 0x23, {KEY_PROG3} },    /* P_Key */
> >>   	{KE_KEY, 0x24, {KEY_PROG4} },    /* Social networking_Key */
> >> +	{KE_KEY, 0x29, {KEY_PROG3} },    /* P_Key for TM8372 */
> >>   	{KE_IGNORE, 0x41, {KEY_MUTE} },
> >>   	{KE_IGNORE, 0x42, {KEY_PREVIOUSSONG} },
> >>   	{KE_IGNORE, 0x43, {KEY_NEXTSONG} },
> >
> > This patch has no problem, but could you please provide the dmidecode
> > result to me for reference?
> >
> >
> > Thanks a lot!
> > Joey Lee
> >
> 
> Hi,
> 
> attached you'll find the output of dmidecode on the TM8372. If you need 
> anything else, let me know.
> 
> You're welcome
> 
> Merlin Schumacher
> 
> 

Thanks for your dmidecode log of TM8372, I can keep it for regression
test after add new functions.


Thanks a lot!
Joey Lee


