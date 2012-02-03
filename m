Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab2BCTfq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 14:35:46 -0500
Received: from xes-mad.com ([216.165.139.218]:11011 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755568Ab2BCTfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 14:35:44 -0500
Date: Fri, 03 Feb 2012 13:35:33 -0600 (CST)
From: Aaron Sierra <asierra@xes-inc.com>
To: guenter roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>, Peter Tyser <ptyser@xes-inc.com>
Subject: Re: [PATCH 1/3] mfd: Add LPC driver for Intel ICH chipsets
Message-ID: <098d7a9f-a5f9-4908-9253-f2134f08d932@zimbra>
In-Reply-To: <1328296462.2261.193.camel@groeck-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.52.0.65]
X-Mailer: Zimbra 7.1.3_GA_3346 (ZimbraWebClient - GC15 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I ended up making all the changes suggested above (plus the matching
> changes needed in the subsequent patches) while I rebased the code to
> 3.3-rc2. Right now I have an (untested) patchset which applies to
> 3.3-rc2. Please let me know how you would like to proceed; I can send
> it to you if you like, or to the list.

Hey Guenter,
If you want to send me your patchset directly, I can test it out on
some of our hardware (Ibex Peak and Cougar Point). I can work on
implementing some of your other suggestions as well before
resubmitting to the list.

-Aaron
