Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209Ab1KCTld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 15:41:33 -0400
Received: from lo.gmane.org ([80.91.229.12]:46091 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749Ab1KCTlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 15:41:32 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Mantas M." <grawity@gmail.com>
Subject: Re: memstick - old Memory Sticks not recognized
Date: Thu, 03 Nov 2011 21:41:15 +0200
Message-ID: <j8uqos$hdf$1@dough.gmane.org>
References: <j8uq9n$dvd$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 78-60-211-195.static.zebra.lt
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111005 Thunderbird/8.0
In-Reply-To: <j8uq9n$dvd$1@dough.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What I forgot to add:

* The card reader is listed in `lspci` as:
   05:00.3 System peripheral: JMicron Technology Corp. MS Host 
Controller (rev 80)

* The laptop is Asus K52JT.

* The working card is actually Memory Stick Pro Duo, not Pro, but either 
way it works.

* Standard Arch Linux kernel configuration (plus CONFIG_MEMSTICK_DEBUG, 
which I hoped would give me some clues).

-- 
Mantas M.

