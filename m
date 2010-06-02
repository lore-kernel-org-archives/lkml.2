Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933Ab0FBXYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 19:24:05 -0400
Received: from lo.gmane.org ([80.91.229.12]:37983 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758254Ab0FBXYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 19:24:03 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
connect(): No such file or directory
From: "H.S." <hs.samix@gmail.com>
Subject: Re: [PATCH] firewire: core: check for 1394a compliant IRM, fix inaccessibility
 of Sony camcorder
Date: Wed, 02 Jun 2010 19:23:51 -0400
Message-ID: <hu6p68$ft0$1@dough.gmane.org>
References: <AANLkTimIFRbKWYjFd56acxT2A6nnH6l3-7Q_UyORnonW@mail.gmail.com>	<4C017477.8000008@s5r6.in-berlin.de>	<4C0284E7.3050803@s5r6.in-berlin.de>	<tkrat.740b506673ccbf6d@s5r6.in-berlin.de>	<htu993$60f$1@dough.gmane.org>	<4C02B483.9080802@s5r6.in-berlin.de>	<htuebt$l80$1@dough.gmane.org>	<hu0jnr$10b$1@dough.gmane.org> <hu22tj$ne4$1@dough.gmane.org> <4C06A246.9030405@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 206-248-129-141.dsl.teksavvy.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100411 Lightning/1.0b1 Icedove/3.0.4
In-Reply-To: <4C06A246.9030405@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/10 02:26 PM, Stefan Richter wrote:
> 
> I committed the patch to linux1394-2.6.git now, exposed it in the
> linux-next branch, and will send a pull request sometime next week.
> 
> I marked the commit to be back-merged into the stable kernel branches
> (2.6.32.y and newer).  Distributors will pick it up from there at their
> leisure, or earlier if they get a distro bug report that points them to
> the commit.
> 
> Thanks for testing the patched kernel.

Great! I am glad I was able to help.

> 
> I suppose either the local node became root node (node with highest node
> ID) and thus the camcorder stopped doing bus management things, or the
> camcorder chose the optimum gap count 5 for some reason and thus the
> Linux node saw no reason to do its bus management routine.  If you are
> very curious, you can look at node IDs and gap counts and more with the
> FireWire inspection utility gscanbus.


Okay. Thanks again for the explanations.

Warm regards.

-- 

Please reply to this list only. I read this list on its corresponding
newsgroup on gmane.org. Replies sent to my email address are just
filtered to a folder in my mailbox and get periodically deleted without
ever having been read.

