Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab2BBIg1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 03:36:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32876 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754727Ab2BBIgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 03:36:25 -0500
Date: Thu, 2 Feb 2012 09:36:24 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Stephane Chatty <chatty@enac.fr>,
        Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] hid-multitouch: add support for trackpads
In-Reply-To: <CAN+gG=HsiGyCMVHbWm1ri5q5_s8L0Af76B9R8gJVHhKMa8t1FQ@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1202020935390.18918@pobox.suse.cz>
References: <1326887468-5148-1-git-send-email-benjamin.tissoires@enac.fr> <1326887468-5148-2-git-send-email-benjamin.tissoires@enac.fr> <20120120160948.GA18530@polaris.bitmath.org> <20120120164849.GA6520@core.coreip.homeip.net>
 <CAN+gG=HsiGyCMVHbWm1ri5q5_s8L0Af76B9R8gJVHhKMa8t1FQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jan 2012, Benjamin Tissoires wrote:

> Hi Dmitry and Henrik,
> 
> Thanks Dmitry for the comment.
> 
> I'll do the change as you mentioned and will also remove the
> input_mt_report_finger_count call.

Benjamin,

I have just materialized from almost 3 weeks of being offline, so I just 
wanted to check the current status of this.

Are you planning to send v3 of this patchset?

Thanks,

-- 
Jiri Kosina
SUSE Labs
