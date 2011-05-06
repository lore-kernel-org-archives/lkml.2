Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab1EFMmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 08:42:06 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:41647 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751420Ab1EFMmE (ORCPT
	<rfc822;groupwise-jlee@novell.com:7:1>);
	Fri, 6 May 2011 08:42:04 -0400
Message-Id: <4DC47937020000230002C446@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Fri, 06 May 2011 06:41:59 -0600
From: "Joey Lee" <jlee@novell.com>
To: <melchior.franz@gmail.com>
Cc: <chris@chris-wilson.co.uk>, <dri-devel@lists.freedesktop.org>,
        "Joey Lee" <JLee@novell.com>, <carlos@strangeworlds.co.uk>,
        <tiwai@suse.de>, <linux-kernel@vger.kernel.org>
Subject: Re: i915/kms/backlight-combo mode problem
References: <BANLkTimXkXCAKQGK2ysTRNN-xa4ZChxcHA@mail.gmail.com>
 <s5htyd9kumz.wl%tiwai@suse.de> <201105052242.22217@rk-nord.at>
 <201105061052.06638@rk-nord.at>
In-Reply-To: <201105061052.06638@rk-nord.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Melchior, 

於 五，2011-05-06 於 10:52 +0200，Melchior FRANZ 提到：
> * Melchior FRANZ -- Thursday 05 May 2011:
> > This revised patch works correctly for me.
> 
> ... and changing backlight brightness worked with acpi_osi=Linux, too.
> Unfortunately, that does no longer work now, although I haven't changed
> anything. Pressing the brightness buttons causes some ACPI debug output,
> but it doesn't adjust anything.
> 
> m. 

hmm........ Takashi's patch works before, but doesn't work now?

Does that because my new patch for bko#34142 ? Could you please add
acer-wmi to /etc/modprobe.d/blacklist then reboot machine ?

Step:
	- add acer-wmi to /etc/modprobe.d/blacklist
	- shutdown your machine
	- remove AC power and notebook's battery
	- plugin AC power then boot your notebook
	- check the brightness control 


Thank's
Joey Lee

