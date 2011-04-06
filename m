Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab1DFCbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 22:31:25 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41074 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753892Ab1DFCbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 22:31:24 -0400
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Apr 2011 22:31:24 EDT
Message-Id: <1302056737.18143.1437928957@webmail.messagingengine.com>
X-Sasl-Enc: BBGavXs25U86woMaxO/CihC4UBze/vIwYIHgq3KBahL3 1302056737
From: "Adam McLaurin" <lkml@irotas.net>
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
Subject: Question about loopback network interface
Date: Tue, 05 Apr 2011 22:25:37 -0400
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am looking for some information on how exactly the loopback network
interface works. I've done a fair amount of Google/StackOverflow
searching but haven't really found anything particularly useful.

In particular, I'm interested in 2 things:

1) A diagram of the 'plumbing' of what exactly happens when an app
communications with another local app using TCP

2) How "loopback-aware" is TCP (the implementation in Linux, not the
protocol in general)? For example, does congestion control still come
into play when communicating over loopback? Or does TCP always do the
same thing, regardless of whether it's communicating to a remote or
local app?

Thanks,
Adam

P.S. My apologies for cross-posting this email with linux-net - I looked
at the recent archives of that list and it seems like nothing but spam
