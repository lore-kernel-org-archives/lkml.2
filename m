Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817Ab0IBVLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:11:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44009 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757730Ab0IBVKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:10:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [PATCH] libata: skip EH autopsy and recovery during suspend
Date: Thu, 2 Sep 2010 23:09:56 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Tejun Heo <htejun@gmail.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Stephan Diestelhorst <stephan.diestelhorst@gmail.com>,
        "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>
References: <Pine.LNX.4.44L0.1009021646510.1311-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1009021646510.1311-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009022309.56824.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 02, 2010, Alan Stern wrote:
> On Thu, 2 Sep 2010, Tejun Heo wrote:
> 
> > Hello,
> > 
> > On 09/02/2010 10:28 PM, Rafael J. Wysocki wrote:
> > > That would be very nice.  In particular, I'd like to get rid of the
> > > pm_message_t thing if possible.  And I'd like to avoid putting the
> > > controller into D3 before creating hibernation image. :-)
> 
> Ultimately I don't think it will be possible to get rid of pm_message_t
> throughout the entire kernel.  Not just because it's a legacy thing
> spread all over the place, but because it sometimes is genuinely
> useful.  In situations where there are only minimal differences between
> the various suspend/resume paths, it makes a lot of sense to call a
> single function and tell it which type of operation to perform.

Well, that's why I said "if possible" above. :-)

Thanks,
Rafael
