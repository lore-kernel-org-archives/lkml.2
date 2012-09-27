Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab2I0HEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 03:04:32 -0400
Received: from orion.CARNet.hr ([161.53.160.90]:59707 "EHLO orion.carnet.hr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756562Ab2I0HEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 03:04:31 -0400
Date: Thu, 27 Sep 2012 09:04:26 +0200
From: Josip Rodin <joy@debbugs.entuzijast.net>
To: Nestor Lopez Casado <nlopezcasad@logitech.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        685360@bugs.debian.org, john.ettedgui@gmail.com, barz621@gmail.com,
        dh.herrmann@googlemail.com
Subject: Re: [PATCH 1/1] HID: Fix missing Unifying device issue
Message-ID: <20120927070426.GA27734@entuzijast.net>
References: <1348222894-6767-1-git-send-email-nlopezcasad@logitech.com>
 <20120923102318.GA12946@entuzijast.net>
 <CAE7qMroQOxo7kci7roLbS5HXjpkyhRi=cj1WCoYtAPB328xNQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE7qMroQOxo7kci7roLbS5HXjpkyhRi=cj1WCoYtAPB328xNQg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 11:30:28AM +0200, Nestor Lopez Casado wrote:
> Josip, this is a different issue from the one addressed with the patch.
> 
> 1) Can you try it on a 3.2 kernel ?

I can try that too, I'll let you know how it went.

(Unfortunately the machine is in the same room with a crib, so I don't
get a lot of time slots for testing. *shrug* :)

> 2) The problem you describe, does it happen all the time ?

Yes. The keyboard simply stopped working after I upgraded to Linux 3.2.
It works fine under 3.1 and earlier, and under Windows.

-- 
     2. That which causes joy or happiness.
