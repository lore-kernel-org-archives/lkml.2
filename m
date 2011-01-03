Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab1ACRDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 12:03:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674Ab1ACRDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 12:03:45 -0500
Date: Mon, 3 Jan 2011 18:03:17 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: castet.matthieu@free.fr
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, stf_xl@wp.pl,
        tj@kernel.org
Subject: Re: your mail
Message-ID: <20110103170308.GA2285@redhat.com>
References: <1294072680.4d21fb68cbdcf@imp.free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294072680.4d21fb68cbdcf@imp.free.fr>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 03, 2011 at 05:38:00PM +0100, castet.matthieu@free.fr wrote:
> Hi,
> 
> could you CC me on ueagle-atm.c patches.
> 
> From what I remind we sleep in the workqueue, that's why we couldn't use the
> system one (freeze keyboard...). But may be the code changed.
In case when firmware is not available we can sleep for a few seconds in
work function. That's block keyboard driver who also use common workqueue.
If recent Tejun workqueue rewrite allow to long sleep in work func and
not hurt other workqueue users, patch is ok.

Unfortunately I'm not able to test the patch, my ueagle device was physically
damaged a few months ago.

Stanislaw
