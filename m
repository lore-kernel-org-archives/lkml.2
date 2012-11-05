Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981Ab2KEVcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 16:32:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44671 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab2KEVcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 16:32:12 -0500
Message-ID: <50983069.5080404@canonical.com>
Date: Mon, 05 Nov 2012 15:32:25 -0600
From: Chris J Arges <chris.j.arges@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] hid: usbhid: add quirk for SB arena headset v2
References: <1352145945-8035-1-git-send-email-chris.j.arges@canonical.com> <alpine.LNX.2.00.1211052117210.24253@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1211052117210.24253@pobox.suse.cz>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2012 02:18 PM, Jiri Kosina wrote:
> On Mon, 5 Nov 2012, Chris J Arges wrote:
> 
>> When an SB Arena USB headset is plugged in, it registers the volume
>> keys on the headset as a keyboard and continually sends events causing
>> issues with normal keyboard input. This quirk disables the volume keys.
> 
> I don't know how the device looks like, but wouldn't it make more sense to 
> actually remap the bogus keys it's sending to produce KEY_VOLUMEUP and 
> KEY_VOLUMEDOWN?
> 

Yes, if I can track this hardware down or get data I'll fix it like
this. This happened to be a do-no harm fix for the following bug:
https://bugs.launchpad.net/ubuntu/+source/xorg-server/+bug/1007575

Thanks for the feedback.
--chris j arges
