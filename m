Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab2FKAqK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 20:46:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039Ab2FKAqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 20:46:08 -0400
Date: Sun, 10 Jun 2012 20:46:02 -0400
From: Dave Jones <davej@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: oomkillers gone wild.
Message-ID: <20120611004602.GA29713@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Rientjes <rientjes@google.com>,
	KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
References: <20120604152710.GA1710@redhat.com>
 <alpine.DEB.2.00.1206041629500.7769@chino.kir.corp.google.com>
 <20120605174454.GA23867@redhat.com>
 <alpine.DEB.2.00.1206081313000.19054@chino.kir.corp.google.com>
 <20120608210330.GA21010@redhat.com>
 <alpine.DEB.2.00.1206091920140.7832@chino.kir.corp.google.com>
 <4FD412CB.9060809@gmail.com>
 <20120610201055.GA27662@redhat.com>
 <alpine.DEB.2.00.1206101652180.18114@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1206101652180.18114@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2012 at 04:52:50PM -0700, David Rientjes wrote:
 > On Sun, 10 Jun 2012, Dave Jones wrote:
 > 
 > > To double check, here it is in rc2 (which has that patch)..
 > > 
 > > $ uname -r
 > > 3.5.0-rc2+
 > > $ cat /proc/$(pidof dbus-daemon)/oom_score{_adj,}
 > > -900
 > > 7441500919753
 > > $ grep RSS /proc/$(pidof dbus-daemon)/status
 > > VmRSS:	    1604 kB
 > 
 > Eek, yes, that's definitely wrong.  The following should fix it.

now prints..

-900
0

which I assume is much better ;-)

	Dave
