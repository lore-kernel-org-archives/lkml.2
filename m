Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab1COJGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 05:06:30 -0400
Received: from mx4.orcon.net.nz ([219.88.242.54]:48387 "EHLO mx4.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829Ab1COJG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 05:06:28 -0400
Message-ID: <4D7F2C11.907@orcon.net.nz>
Date: Tue, 15 Mar 2011 22:06:25 +1300
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-alpha@vger.kernel.org, warns@pre-sense.de,
        torvalds@linux-foundation.org
Subject: Alpha no longer recognises certain partition tables (v2.6.38)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx4.orcon.net.nz on Tue, 15 Mar 2011 22:06:27 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Tue Mar 15 22:06:27 2011
X-DSPAM-Confidence: 0.5503
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2.6.38 boot reports it can't recognise the partition table on the 
system disk on my Alpha and panics when it can't find the root device.

It worked at v2.6.38-rc7.

While I haven't done a bisect to fully verify I nevertheless suggest the 
following patch as the likely cause:

1eafbfe Fix corrupted OSF partition table parsing

Cheers
Michael.
