Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab1KXGcs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 01:32:48 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63339 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab1KXGcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 01:32:47 -0500
MIME-Version: 1.0
In-Reply-To: <20111124171949.994860621f4f83a650cf9b5b@canb.auug.org.au>
References: <20111114142423.fe126b8c8cfd275d7dd138cc@canb.auug.org.au>
	<201111150012.56306.rjw@sisk.pl>
	<20111124171949.994860621f4f83a650cf9b5b@canb.auug.org.au>
Date: Wed, 23 Nov 2011 22:32:45 -0800
X-Google-Sender-Auth: xHsdDBkLf4QYZkE0aBjDaOOct4I
Message-ID: <CAOS58YPAh3e_sa4JrHdVD40scNED5Z4g4t6JNU8MT8kq8vZV2Q@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree (pm tree related)
From: Tejun Heo <tj@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Nov 23, 2011 at 10:19 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> > Subject: [PATCH] freezer: fix more fallout from the thaw_process rename
>> >
>> > Commit 944e192db53c "freezer: rename thaw_process() to __thaw_task()
>> > and simplify the implementation" did not create a !CONFIG_FREEZER version
>> > of __thaw_task().
>> >
>> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>>
>> I've applied your patch to linux-pm/pm-freezer and merged it into
>> linux-pm/linux-next.

Ah.. that's my bad. I was actually looking at that diff and somehow it
just slipped my mind. Rafael, can you please apply Stephen's patch on
top of pm-freezer?

Thank you.

-- 
tejun
