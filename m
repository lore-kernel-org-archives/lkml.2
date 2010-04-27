Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab0D0IZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 04:25:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45786 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730Ab0D0IZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 04:25:04 -0400
Date: Tue, 27 Apr 2010 10:25:00 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jirislaby@gmail.com>, Alan Ott <alan@signal11.us>
Cc: Stephane Chatty <chatty@enac.fr>, Marcel Holtmann <marcel@holtmann.org>,
       simon.windows@gmail.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Bug in hidraw When a HID Device Contains Multiple
 Reports
In-Reply-To: <4BD69047.3010703@gmail.com>
Message-ID: <alpine.LNX.2.00.1004271024140.7579@pobox.suse.cz>
References: <4BD61506.1030301@signal11.us> <4BD69047.3010703@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Apr 2010, Jiri Slaby wrote:

> On 04/27/2010 12:34 AM, Alan Ott wrote:
> > Make hidraw not stick an extra byte on the beginning of an IN transfer
> > when a HID device contains multiple reports.
> ...
> > I have attached a patch which seems to take care of this problem. Please
> > let me know if I have completely misjudged the situation.
> 
> Nope, your analysis is correct. It was introduced by me in 85cdaf524. I
> apparently forgot to change the hidraw case, so your fix is OK.

Yeah, the analysis is correct, thanks a lot for catching this Alan!

I have put 

	Acked-by: Jiri Slaby <jslaby@suse.cz>

to the patch and applied it.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
