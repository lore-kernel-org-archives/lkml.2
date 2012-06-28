Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901Ab2F1KKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 06:10:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56741 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165Ab2F1KKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 06:10:47 -0400
Date: Thu, 28 Jun 2012 12:10:40 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] HID: hid-multitouch: fix input mode feature
 command
In-Reply-To: <CAN+gG=GRO3PXK1QF4rUq49Z-7gXd6VDz=cbTNNmJBP6NLcgCKQ@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1206281209530.17549@pobox.suse.cz>
References: <1340109594-10732-1-git-send-email-benjamin.tissoires@gmail.com> <alpine.LNX.2.00.1206281030070.17549@pobox.suse.cz> <CAN+gG=GRO3PXK1QF4rUq49Z-7gXd6VDz=cbTNNmJBP6NLcgCKQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2012, Benjamin Tissoires wrote:

> Thanks a lot for that.
> My apologies. I didn't thanked Henrik and commented his review. So
> thank you Henrik. (the "break" here is not an optimisation as
> field->maxusage may be greater than the real report count).

Yes, I thought so, and therefore applied that patch. 2/3 I am still 
keeping unapplied.

> I'm currently quite overloaded with the hid over i2c bus, and I'm 
> getting some very goods results. I'm stuck with the acpi part, but the 
> rest of it is working pretty good for a draft. I'll keep you inform 
> soon.

Sounds great, looking forward to seeing the implementation :)

Thanks,

-- 
Jiri Kosina
SUSE Labs
