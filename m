Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab2JWCOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 22:14:35 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:5922 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438Ab2JWCOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 22:14:34 -0400
From: Jian-Jhong Ding <jj_ding@emc.com.tw>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Scott Liu <scott.liu@emc.com.tw>, linux-input@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jesse <jesse@emc.com.tw>, Vincent Wang <vincent.wang@emc.com.tw>,
        Paul <paul.liang@emc.com.tw>
Subject: Re: [PATCH v1] Support Elan Touchscreen eKTF product.
In-Reply-To: <20121022160705.GC13791@core.coreip.homeip.net>
References: <1350424679-20725-1-git-send-email-scott.liu@emc.com.tw> <87hapnnp5t.fsf@emc.com.tw> <20121022160705.GC13791@core.coreip.homeip.net>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 23 Oct 2012 10:14:32 +0800
Message-ID: <87pq4aq6if.fsf@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov <dmitry.torokhov@gmail.com> writes:
> On Mon, Oct 22, 2012 at 11:47:42AM +0800, Jian-Jhong Ding wrote:
>> With Benjamin's i2c-hid implimentation, is it possible to make
>> hid-multitouch not depend on USBHID and reuse it to drive this device?
>
> Exactly. Before looking any further - is this the same part that Tom Lin
> posted a driver for earlier this summer?

No.  Tom's driver was only for trackpads, this is probably for some
touch panel.  The controller ICs may have some similarities, but the
firmware is developed independently, though both somewhat conform to the
HID over I2C protocol.

Thanks,
-JJ
> Thanks.
>
> -- 
> Dmitry
