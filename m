Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab0E3Ts6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 15:48:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59281 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670Ab0E3Tsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 15:48:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [linux-pm] [patch] complain when users abuse the pm_qos API
Date: Sun, 30 May 2010 21:50:01 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-tst; KDE/4.3.5; x86_64; ; )
Cc: markgross@thegnar.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <20100529045027.GE11600@gvim.org> <201005292208.04309.rjw@sisk.pl> <4C019D36.8070405@crca.org.au>
In-Reply-To: <4C019D36.8070405@crca.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005302150.01452.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 30 May 2010, Nigel Cunningham wrote:
> Hi.
> 
> On 30/05/10 06:08, Rafael J. Wysocki wrote:
> > On Saturday 29 May 2010, mark gross wrote:
> >> The following patch is to help clean up API abusers of pm_qos where
> >> they call update_request before registering a request.
> >>
> >> --mgross
> >>
> >> --Signed-off-by: markgross<markgross@thegnar.org>
> >
> > Will there be a big issue if I push this during the next merge window?
> 
> What's the point to the patch? That is: why is calling update_request 
> before registering a request such a big problem that it demands a WARN() 
> and dump stack?

It is an API violation if I understand that correctly.

Rafael
