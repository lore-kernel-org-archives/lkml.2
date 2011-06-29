Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab1F2XZD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 19:25:03 -0400
Received: from 64-186-171-137.static-ip.telepacific.net ([64.186.171.137]:60466
	"EHLO l.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab1F2XY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 19:24:57 -0400
X-Greylist: delayed 1782 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jun 2011 19:24:57 EDT
Message-ID: <4E0BAD16.5020701@chelsio.com>
Date: Wed, 29 Jun 2011 15:54:14 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: linux-kernel@vger.kernel.org, Dimitris Michailidis <dm@chelsio.com>,
        Neil Horman <nhorman@tuxdrivers.com>
Subject: [PATCH] linux-firmware: update cxgb4 firmware
References: <4DAF5497.9070404@chelsio.com>
In-Reply-To: <4DAF5497.9070404@chelsio.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Can you please pull from git://git.chelsio.net/pub/git/linux-firmware.git?

It contains the following commit, updating the firmware file for the 
cxgb4 ethernet driver:

commit 6af51ebf350148bde17c73bacb3c59d8c3e2461a
Author: Divy Le Ray <divy@chelsio.com>
Date:   Wed Jun 29 14:18:16 2011 -0700

     linux-firmware: Update cxgb4 firmware

     Update cxgb4 firmware to revision 1.3.10.0

     Signed-off-by: Divy Le Ray <divy@chelsio.com>

Cheers,
Divy
