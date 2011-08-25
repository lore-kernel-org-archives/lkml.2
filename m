Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab1HYVBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 17:01:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38768 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577Ab1HYVBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 17:01:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] oom: skip frozen tasks
Date: Thu, 25 Aug 2011 23:03:17 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
References: <20110823073101.6426.77745.stgit@zurg> <20110825091920.GA22564@tiehlicka.suse.cz> <20110825151818.GA4003@redhat.com>
In-Reply-To: <20110825151818.GA4003@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108252303.17446.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 25, 2011, Oleg Nesterov wrote:
> On 08/25, Michal Hocko wrote:
> >
> > On Wed 24-08-11 12:31:26, David Rientjes wrote:
> > >
> > > That's obviously false since we call oom_killer_disable() in 
> > > freeze_processes() to disable the oom killer from ever being called in the 
> > > first place, so this is something you need to resolve with Rafael before 
> > > you cause more machines to panic.
> >
> > I didn't mean suspend/resume path (that is protected by oom_killer_disabled)
> > so the patch doesn't make any change.
> 
> Confused... freeze_processes() does try_to_freeze_tasks() before
> oom_killer_disable() ?

Yes, it does.

Thanks,
Rafael
