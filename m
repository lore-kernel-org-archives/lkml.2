Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952Ab1AMML5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 07:11:57 -0500
Received: from beauty.rexursive.com ([150.101.121.179]:51977 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932856Ab1AMMLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 07:11:53 -0500
Subject: Re: [linux-pm] Oops while going into hibernate
Date: Thu, 13 Jan 2011 23:11:45 +1100
From: "Bojan Smojver" <bojan@rexursive.com>
To: sebott@linux.vnet.ibm.com
Cc: tytso@mit.edu, linux-pm@lists.linux-foundation.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
X-Mailer: LCG ProfiMail
Message-ID: <6009472527.979427505@rexursive.com>
References: <alpine.LFD.2.02.1101121443230.1900@localhost6.localdomain6> <20110112162655.GA13496@thunk.org> <alpine.LFD.2.02.1101121755400.2011@localhost6.localdomain6> <20110112172646.GB13496@thunk.org> <alpine.LFD.2.02.1101121934060.2011@localhost6.localdomain6> <A01161D0-D08F-4522-A546-90057B2E1F2A@mit.edu> <alpine.LFD.2.02.1101131238480.1899@localhost6.localdomain6>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes. I basically did a
> echo reboot > /sys/power/disk
> for i in {1..5} ;do echo disk > /sys/power/state ;done
> and it crashed very early in the second suspend.

Was compression on or off?

--
Bojan 
