Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606Ab2AHF4g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 00:56:36 -0500
Received: from claw.goop.org ([74.207.240.146]:57887 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab2AHF4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 00:56:35 -0500
Message-ID: <4F09300D.8010608@goop.org>
Date: Sun, 08 Jan 2012 16:56:29 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [GIT] HID
References: <alpine.LNX.2.00.1201052218200.24984@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1201052218200.24984@pobox.suse.cz>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2012 08:39 AM, Jiri Kosina wrote:
> Jeremy Fitzhardinge (3):
>       HID: debugfs: decode Generic Device Controls Usage Page
>       HID: hid-input: add support for HID devices reporting Battery Strength
>       HID: hid-input: fix compile for !HID_BATTERY_STRENGTH

Unfortunately it looks like you picked up the old version of these
patches, which will work on my BT mouse, but fail on some Apple
devices.  I'll post an update in an hour or two.

    J
