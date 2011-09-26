Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab1IZA10 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 20:27:26 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45961 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab1IZA1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 20:27:25 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 26 Sep 2011 09:26:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Wizard <wizarddewhite@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: Re: Seems the comment of find_next_system_ram() is not exact
Message-Id: <20110926092641.38e6e490.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <CAOkaeLJHE-BVM+KOpB5hd0Jd_wyk0-XY=Qhzk+0j_U9opCbr-g@mail.gmail.com>
References: <CAOkaeLJTeewFWpHCVBqNwmuL7nEbFYnrQ86SQOO7fVg_Uc3Q4Q@mail.gmail.com>
	<20110925094222.GA11289@liondog.tnic>
	<CAOkaeLJHE-BVM+KOpB5hd0Jd_wyk0-XY=Qhzk+0j_U9opCbr-g@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Sep 2011 23:02:47 +0800
Wizard <wizarddewhite@gmail.com> wrote:

> Borislav
> 
> Thanks for your reply and for your suggestion to use "git annotate".
> I learned a lot from you.
> 
> I see the commit by KAMEZAWA. While still not know why he change
> code this way to cover the overlap case.
> 

yes. comment is wrong. I cannot write patch now. could you fix ?


Thanks,
-Kame

