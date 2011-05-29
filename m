Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab1E2JEt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 05:04:49 -0400
Received: from lo.gmane.org ([80.91.229.12]:53343 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916Ab1E2JEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 05:04:48 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Niels <zorglub_olsen@hotmail.com>
Subject: Re: Trace during boot
Date: Sun, 29 May 2011 11:04:28 +0200
Message-ID: <irt26s$me6$1@dough.gmane.org>
References: <irsuji$6h8$1@dough.gmane.org> <20110529081300.GB3762@liondog.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 0x4dd52733.adsl.cybercity.dk
User-Agent: KNode/0.10.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 May 2011 10:13, Borislav Petkov wrote:

> On Sun, May 29, 2011 at 10:02:59AM +0200, Niels wrote:
>> Hi list, I got the below trace during boot (got it from dmesg). I don't
>> know if it's anything serious, just thought I'd pass it on.
> 
> No, nothing serious, just a warning about syslog-ng using a deprecated
> syslog access method.
> 
[snip rest]

Thank you! I'll update my syslog-ng if the error annoys me enough.


//Niels

