Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab0E3UyT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 16:54:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59487 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572Ab0E3UyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 16:54:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: markgross@thegnar.org
Subject: Re: [linux-pm] [patch] complain when users abuse the pm_qos API
Date: Sun, 30 May 2010 22:55:24 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-tst; KDE/4.3.5; x86_64; ; )
Cc: Nigel Cunningham <ncunningham@crca.org.au>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20100529045027.GE11600@gvim.org> <201005302150.01452.rjw@sisk.pl> <20100530201142.GC25545@gvim.org>
In-Reply-To: <20100530201142.GC25545@gvim.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005302255.24807.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 30 May 2010, mark gross wrote:
> On Sun, May 30, 2010 at 09:50:01PM +0200, Rafael J. Wysocki wrote:
> > On Sunday 30 May 2010, Nigel Cunningham wrote:
> > > Hi.
> > > 
> > > On 30/05/10 06:08, Rafael J. Wysocki wrote:
> > > > On Saturday 29 May 2010, mark gross wrote:
> > > >> The following patch is to help clean up API abusers of pm_qos where
> > > >> they call update_request before registering a request.
> > > >>
> > > >> --mgross
> > > >>
> > > >> --Signed-off-by: markgross<markgross@thegnar.org>
> > > >
> > > > Will there be a big issue if I push this during the next merge window?
> > > 
> > > What's the point to the patch? That is: why is calling update_request 
> > > before registering a request such a big problem that it demands a WARN() 
> > > and dump stack?
> > 
> > It is an API violation if I understand that correctly.
> 
> Yeah, it is, but now that I'm thinking clearly perhaps a better fix
> would be to change the prototype of pm_qos_update_request to return
> something so callers can check for success.
> 
> Lets fix the API rather than use this patch.  Please dopt apply it.

OK

Rafael
