Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab2JVQHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 12:07:23 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:58765 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547Ab2JVQHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 12:07:20 -0400
Date: Mon, 22 Oct 2012 09:07:05 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jian-Jhong Ding <jj_ding@emc.com.tw>
Cc: Scott Liu <scott.liu@emc.com.tw>, linux-input@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jesse <jesse@emc.com.tw>, Vincent Wang <vincent.wang@emc.com.tw>,
        Paul <paul.liang@emc.com.tw>
Subject: Re: [PATCH v1] Support Elan Touchscreen eKTF product.
Message-ID: <20121022160705.GC13791@core.coreip.homeip.net>
References: <1350424679-20725-1-git-send-email-scott.liu@emc.com.tw>
 <87hapnnp5t.fsf@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hapnnp5t.fsf@emc.com.tw>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 11:47:42AM +0800, Jian-Jhong Ding wrote:
> Scott Liu <scott.liu@emc.com.tw> writes:
> > +
> > +struct mt_device {
> > +	struct mt_slot curdata;	/* placeholder of incoming data */
> > +	__u8 num_received;	/* how many contacts we received */
> > +	__u8 num_expected;	/* expected last contact index */
> > +	__u8 maxcontacts;
> > +	bool curvalid;		/* is the current contact valid? */
> > +	struct mt_slot *slots;
> > +};
> 
> With Benjamin's i2c-hid implimentation, is it possible to make
> hid-multitouch not depend on USBHID and reuse it to drive this device?

Exactly. Before looking any further - is this the same part that Tom Lin
posted a driver for earlier this summer?

Thanks.

-- 
Dmitry
