Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab0EQV5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 17:57:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38783 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870Ab0EQV5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 17:57:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: markgross@thegnar.org
Subject: Re: [patch] pm_qos update fixing mmotm 2010-05-11 -dies in pm_qos_update_request()
Date: Mon, 17 May 2010 23:58:00 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: Valdis.Kletnieks@vt.eu, mgross@linux.intel.com, akpm@linux-foundation.org,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <20100515021922.GA5041@thegnar.org> <201005170021.25427.rjw@sisk.pl> <20100517001241.GA2962@thegnar.org>
In-Reply-To: <20100517001241.GA2962@thegnar.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005172358.00076.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 May 2010, mgross wrote:
> On Mon, May 17, 2010 at 12:21:25AM +0200, Rafael J. Wysocki wrote:
> > On Saturday 15 May 2010, mgross wrote:
> > > On Sat, May 15, 2010 at 09:38:47PM +0200, Rafael J. Wysocki wrote:
> > > > On Saturday 15 May 2010, mgross wrote:
> > > > > I apologize for the goofy email address.  
> > > > > 
> > > > > The following is a fix for the crash reported by Valdis.
> > > > > 
> > > > > The problem was that the original pm_qos silently fails when a request
> > > > > update is passed to a parameter that has not been added to the list
> > > > > yet.  It seems that the e1000e is doing this.  This update restores this
> > > > > behavior.
> > > > > 
> > > > > I need to think about how to better handle such abuse, but for now this
> > > > > restores the original behavior.
> > > > 
> > > > Can you please post a signed-off incremental patch against
> > > > 
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git for-llinus
> > > > 
> > > > that contains your original PM QOS update?
> > > 
> > > No problem:
> > >
> > > Signed-off-by: markgross <markgross@thegnar.org>
> > 
> > Thanks!  Do you want to use this address for the sign-off or the Intel one?
> 
> I guess so.  Ever since switching groups within intel last summer my
> mgross@linux.intel.com address isn't checked as often as this one. 
> 
> The other option is to use my outlook email (mark.gross@intel.com), but
> I really hate posting from outlook.  Besides, doing upstream kernel
> stuff isn't my day job any more so using markgross@thegnar.org  makes
> sense to me.

Good.  Patch applied to suspend-2.6/for-linus.

Thanks,
Rafael
