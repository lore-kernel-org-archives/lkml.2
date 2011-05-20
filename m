Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935627Ab1ETLht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 07:37:49 -0400
Received: from cantor.suse.de ([195.135.220.2]:44324 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572Ab1ETLhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 07:37:48 -0400
Date: Fri, 20 May 2011 13:37:45 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] hid-multitouch: class MT_CLS_STANTUM is redundant
 with MT_CLS_CONFIDENCE
In-Reply-To: <BANLkTim1nGEbBo2Zf6gfTzAAZJK5vmpy6A@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1105201336280.28291@pobox.suse.cz>
References: <1305807498-8785-1-git-send-email-benjamin.tissoires@enac.fr> <1305807498-8785-7-git-send-email-benjamin.tissoires@enac.fr> <alpine.LNX.2.00.1105201031560.28291@pobox.suse.cz> <BANLkTim1nGEbBo2Zf6gfTzAAZJK5vmpy6A@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 May 2011, Benjamin Tissoires wrote:

> > is it intentional that you are leaving the hole in the numbering here?
> >
> > I don't think there would be any issue with re-numbering 7-10, would it?
> 
> Well, the first time I tried to renumber those classes (to keep them
> alphabetically sorted), I've been told not to do it. That's why I let
> the hole in this case.
> There won't be any issue in renumbering those classes (and we could sort them).
> Maybe I can just send a new patch on top of this to sort them.

OK. Well, I don't really care personally much, I was just wondering why 
leaving it unnecessarily sparse.

I have applied the whole series now, thanks.

> PS: and thank you very much for applying so quickly the last patches I 
> sent.

I am preparing the tree for merge window push, so I rather have everything 
sorted out in the upcoming day or two.

Thanks,

-- 
Jiri Kosina
SUSE Labs
