Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313Ab1BJX07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:26:59 -0500
Received: from cooldavid.org ([114.33.45.68]:37319 "EHLO cooldavid.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756018Ab1BJX06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:26:58 -0500
From: "Guo-Fu Tseng" <cooldavid@cooldavid.org>
To: "Leonardo  L. P. da Mata" <barroca@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: jme driver loses connection after resuming from suspend
Date: Fri, 11 Feb 2011 07:26:58 +0800
Message-Id: <20110210232658.M45636@cooldavid.org>
In-Reply-To: <AANLkTikV9Ncy3Jki1G20SrzA_HMiAk_hF3qY8U+vpZ1D@mail.gmail.com>
References: <AANLkTikrKEY7Zt5HvxQcJLk9eGne0BGD82NFEiWO4smt@mail.gmail.com> <20110128163315.1e4e8346.akpm@linux-foundation.org> <AANLkTikV9Ncy3Jki1G20SrzA_HMiAk_hF3qY8U+vpZ1D@mail.gmail.com>
X-Mailer: OpenWebMail 2.53 
X-OriginatingIP: 114.33.146.108 (cooldavid)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Leonardo  L. P. da Mata:
The value of register which holds receive Unicast MAC Address somehow
get messed-up after resume!

Would you see if this source fix the issue:
http://bbs.cooldavid.org/git/?p=jme.git;a=snapshot;h=refs/heads/resumefix;sf=tbz2

The shortlog is here:
http://bbs.cooldavid.org/git/?p=jme.git;a=shortlog;h=refs/heads/resumefix


On Thu, 10 Feb 2011 19:07:31 -0200, Leonardo  L. P. da Mata wrote
> Updated information on the bug, Guo-Fu Tseng says that might not be a
> bug on the driver, but i've tested other network cards and they don't
> share the same issue.
> 
> Also, on interesting update that people may consider is that after
> running tcpdump on the device, the network starts working again.
> Information are updated in the bug.
> 
> On Fri, Jan 28, 2011 at 10:33 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > (cc's added)
> >
> > On Fri, 28 Jan 2011 16:03:11 -0200
> > "Leonardo &#160;L. P. da Mata" <barroca@gmail.com> wrote:
> >
> >> Hello, i'm testing the kernel 2.6.37 on my hardware, Once connect on
> >> wired network, i call the suspend with:
> >> echo "mem" >/sys/power/state
> >>
> >> The system goes on suspend. After resuming from suspend, the network card
> >> cannot be used anymore.
> >>
> >>
> >> The bug is reported here:
> >> &#160;https://bugzilla.kernel.org/show_bug.cgi?id=27692
> >>
> >> Can you please point me to similar problems on other network cards so
> >> i can get possible solutions on this.
> >
> >
> 
> -- 
> Leonardo Luiz Padovani da Mata
> barroca@gmail.com
> 
> "May the force be with you, always"
> "Nerd Pride... eu tenho. Voce tem?"
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Guo-Fu Tseng

