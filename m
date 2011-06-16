Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab1FPTJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 15:09:47 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59108 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086Ab1FPTJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 15:09:44 -0400
Date: Thu, 16 Jun 2011 16:10:00 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Chase Douglas <chase.douglas@canonical.com>, Ed Tomlinson <edt@aei.ca>,
        Greg KH <gregkh@suse.de>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.39.1
Message-ID: <20110616191000.GB2594@joana>
Mail-Followup-To: Jiri Kosina <jkosina@suse.cz>,
	Chase Douglas <chase.douglas@canonical.com>,
	Ed Tomlinson <edt@aei.ca>, Greg KH <gregkh@suse.de>,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20110603003835.GA20381@kroah.com>
 <201106032236.41294.edt@aei.ca>
 <4DED20C6.1020701@canonical.com>
 <201106061926.14661.edt@aei.ca>
 <4DEF9705.4070502@canonical.com>
 <20110608180146.GB13036@joana>
 <alpine.LNX.2.00.1106130010360.22872@pobox.suse.cz>
 <20110613172739.GA2661@joana>
 <alpine.LNX.2.00.1106161224350.22872@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1106161224350.22872@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jiri Kosina <jkosina@suse.cz> [2011-06-16 12:25:32 +0200]:

> On Mon, 13 Jun 2011, Gustavo F. Padovan wrote:
> 
> > > > > Where did this patch come from? I don't see it in Linus' tree. If this
> > > > > patch is merged, I can test the a new kernel out to see if we should
> > > > > back out the commit from Jiri. However, right now my magic trackpad
> > > > > (which has the same issue as the magic mouse) works fine on plain 2.6.39.1.
> > > > 
> > > > This patch is in my tree. It will be on its way to Linus' tree today.
> > > 
> > > Doesn't seem to be present in Linus' tree as of today. Has there been any 
> > > issue discovered in the meantime?
> > 
> > No, it is on wireless-2.6 right now. Then goes to net-2.6 and finally linus-2.6.
> 
> Still doesn't seem to be present in Linus' tree today.
> 
> Could you please point me to where it is queued now? I am going to revert 
> the "workaround" I have for magicmouse today (which is buggy), but I want 
> to make sure that the actual fix (i.e. Villo's patch) flows in soon.

Yes, still on wireless-2.6 . :(

I'll check if I can make it go fast.

	Gustavo
