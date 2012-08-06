Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab2HFBHn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 21:07:43 -0400
Received: from netrider.rowland.org ([192.131.102.5]:50298 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755029Ab2HFBHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 21:07:42 -0400
Date: Sun, 5 Aug 2012 21:07:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Todd Poynor <toddpoynor@google.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <arve@android.com>
Subject: Re: [PATCH v2] PM / Sleep: Print name of wakeup source that aborts
 suspend
In-Reply-To: <201208052349.42606.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1208052106110.21764-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Aug 2012, Rafael J. Wysocki wrote:

> > v2
> > use ktime_to_ns() instead of comparisons on .tv64 field

What is the reason for this?  It apparently adds complexity and code 
(on non-64-bit systems) to no purpose.

Alan Stern

