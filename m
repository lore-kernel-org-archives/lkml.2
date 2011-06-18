Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab1FRBRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 21:17:40 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:43128 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab1FRBRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 21:17:37 -0400
Subject: Re: [Bugme-new] [Bug 37682] New: Kernel mis-detects size/position
 of partition created with Seagate DiscWizard (OnTrack Disk Manager)
From: Paul Bolle <pebolle@tiscali.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: markk@clara.co.uk, bugme-daemon@bugzilla.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 18 Jun 2011 03:16:53 +0200
References: <bug-37682-10286@https.bugzilla.kernel.org/>
	 <20110617143104.3b883bda.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.1 (3.1.1-3.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1308359856.2166.23.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-06-18 at 03:01 +0200, Paul Bolle wrote:
> nor could I find the commit(s) that removed it.

That was 232595eaff951e96cabe5e85fed35f66b72ff51e ("ide: remove
obsoleted "hdx=" kernel parameters"), which was applied in the v2.6.27
cycle.


Paul Bolle

