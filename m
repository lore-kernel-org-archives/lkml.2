Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab2HFLJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 07:09:21 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:43792 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801Ab2HFLJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 07:09:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2] PM / Sleep: Print name of wakeup source that aborts suspend
Date: Mon, 6 Aug 2012 13:15:13 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Todd Poynor <toddpoynor@google.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arve@android.com
References: <Pine.LNX.4.44L0.1208052106110.21764-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1208052106110.21764-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208061315.13302.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 06, 2012, Alan Stern wrote:
> On Sun, 5 Aug 2012, Rafael J. Wysocki wrote:
> 
> > > v2
> > > use ktime_to_ns() instead of comparisons on .tv64 field
> 
> What is the reason for this?  It apparently adds complexity and code 
> (on non-64-bit systems) to no purpose.

I don't think accessing the internals of ktime_t is appropriate,
even though avoiding that may result in some computational cost.

Thanks,
Rafael
