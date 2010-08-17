Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914Ab0HQQWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 12:22:48 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:36852 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab0HQQWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 12:22:47 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C6AB741.9050804@s5r6.in-berlin.de>
Date: Tue, 17 Aug 2010 18:22:25 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Peter Zijlstra <peterz@infradead.org>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: lockdep false positive? -- firewire-core transaction timer vs.
 scsi-core host lock
References: <tkrat.1e48e021935dc8b7@s5r6.in-berlin.de>	 <1281994939.1926.2075.camel@laptop> <1281997633.3683.50.camel@jlt3.sipsolutions.net>
In-Reply-To: <1281997633.3683.50.camel@jlt3.sipsolutions.net>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Berg wrote:
> I'm convinced it's a false positive though, question is how to shut it
> up :-)

Is there anyway to differentiate the lockdep naming of shost->host_lock
(initialized in scsi_host_alloc) at runtime by means of the
scsi_host_template instance given to scsi_host_alloc?
-- 
Stefan Richter
-=====-==-=- =--- =---=
http://arcgraph.de/sr/
