Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab2CaIKt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 04:10:49 -0400
Received: from claw.goop.org ([74.207.240.146]:43600 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535Ab2CaIKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 04:10:35 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Sat, 31 Mar 2012 04:10:35 EDT
Message-ID: <4F76BA40.90108@goop.org>
Date: Sat, 31 Mar 2012 01:03:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Joseph Salisbury <joseph.salisbury@canonical.com>
CC: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [GIT] HID #2
References: <alpine.LNX.2.00.1201091248360.24984@pobox.suse.cz> <4F71D9C5.9040301@canonical.com> <alpine.LNX.2.00.1203271952580.25526@pobox.suse.cz> <4F75EB05.7000805@canonical.com>
In-Reply-To: <4F75EB05.7000805@canonical.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2012 10:19 AM, Joseph Salisbury wrote:
>
> Thanks for the feedback, Jiri.
>
> I was interested in the following commit for linux-stable for support of
> Apple bluetooth Keyboard(USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ANSI
> 0x0255):
> 652aa6a9ac4a5f8d3e1fa3f6466646519e83c01e hid-input/battery: add FEATURE
> quirk
>
> Jeremy, do you happen to know if this patch can be applied without the
> needing the other 9 patches you provided in this commit?

There's no point; it only relates to getting the keyboard battery level,
which is what the rest of the series does.  It shouldn't make any
functional difference to the keyboard itself.

    J
