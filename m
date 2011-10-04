Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab1JDMFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 08:05:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53414 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756227Ab1JDMFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 08:05:23 -0400
Date: Tue, 4 Oct 2011 14:05:20 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Cc: linux-kernel@vger.kernel.org, "Joshua V. Dillon" <jvdillon@gmail.com>
Subject: Re: [PATCH] HID: Add support MacbookAir 4,1 keyboard
In-Reply-To: <CABMQnV+y+yw-cY9CexT_eVWqsJFkT0ffZLx87y5CRuX=KiOtpQ@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1110041404530.31654@pobox.suse.cz>
References: <1317452093-25555-1-git-send-email-iwamatsu@nigauri.org> <alpine.LNX.2.00.1110031402360.31654@pobox.suse.cz> <alpine.LNX.2.00.1110031415110.31654@pobox.suse.cz> <CABMQnV+y+yw-cY9CexT_eVWqsJFkT0ffZLx87y5CRuX=KiOtpQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Oct 2011, Nobuhiro Iwamatsu wrote:

> >> > Signed-off-by: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
> >>
> >> Applied, thank you.
> >
> Thanks.
> 
> > Oh, and don't we BTW need the hid_mouse_ignore_list[] addition as well? Is
> > the respective mouse being handled properly by appletouch driver?
> 
> I don't work touchpad on MacbookAir yet.
> But I think that the change is necessary when I show a past change.
> And I think that I am necessary for MacbookAir 4,2.
> I made patches, and I attached.

After noticing that bcm5974 already supports mouse interfaces of these, I 
have already fixed it myself in my tree.

Thanks anyway,

-- 
Jiri Kosina
SUSE Labs
