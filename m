Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966169Ab2EOWXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 18:23:30 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:51031 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965655Ab2EOWX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 18:23:28 -0400
Message-ID: <1337120605.2543.1.camel@shrek.rexursive.com>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
From: Bojan Smojver <bojan@rexursive.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>, bp@alien8.de
Date: Wed, 16 May 2012 08:23:25 +1000
In-Reply-To: <201205151942.36335.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1205132212070.5628-100000@netrider.rowland.org>
	 <1337039996.1628.9.camel@shrek.rexursive.com>
	 <4FB269BF.3090801@linux.vnet.ibm.com> <201205151942.36335.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 19:42 +0200, Rafael J. Wysocki wrote:
> which I suppose is what the first Bojan's patch did, right? 

Correct. No extra notifiers were sent, so whatever hibernation code did
was it.

That patch is here:

http://marc.info/?l=linux-kernel&m=133651588229850&w=2

-- 
Bojan

