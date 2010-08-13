Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761415Ab0HMJWH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 05:22:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:36293 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761390Ab0HMJWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 05:22:04 -0400
Subject: Re: [PATCH] ideapad-laptop: add new driver
From: David Woodhouse <dwmw2@infradead.org>
To: Ike Panhc <ike.pan@canonical.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Thomas Renninger <trenn@suse.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <4C64EC01.9040103@canonical.com>
References: <1281672482-10909-1-git-send-email-ike.pan@canonical.com>
	 <AANLkTikBZ2SmqWavZ8bw69yQ_A5GTTcB13RKEzUuUcx3@mail.gmail.com>
	 <4C64EC01.9040103@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Aug 2010 10:22:00 +0100
Message-ID: <1281691320.23680.480.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.6 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-13 at 14:53 +0800, Ike Panhc wrote:
> Could you point me where is the rfkill driver? Sorry I do not find it.

	git://git.infradead.org/users/dwmw2/ideapad-2.6.git
	http://git.infradead.org/users/dwmw2/ideapad-2.6.git

After fixing Corentin's review feedback and conferring with Matthew, I
asked Linus to pull it last night -- without the rfkill support, people
were having to reinstall Windows and use it to unblock the rfkill and
get wireless working.

http://bugs.meego.com/show_bug.cgi?id=4086
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/577114
http://forums.lenovo.com/t5/Linux-Discussion/Solution-to-rfkill-wireless-problems-w-IdeaPad-S12/td-p/224122

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

