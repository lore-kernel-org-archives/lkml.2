Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746Ab2BMTyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 14:54:14 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:46817 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877Ab2BMTyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 14:54:12 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 13 Feb 2012 20:53:32 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Chris Boot <bootc@bootc.net>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de
Subject: Re: [PATCH 06/13] firewire-sbp-target: Add sbp_fabric.{c,h}
Message-ID: <20120213205332.09bc683f@stein>
In-Reply-To: <337FFBD7-6B4A-41CA-BB57-6038C935B5BF@bootc.net>
References: <4E4BD560.4010806@bootc.net>
	<1328989452-20921-1-git-send-email-bootc@bootc.net>
	<1328989452-20921-7-git-send-email-bootc@bootc.net>
	<1329138360.9333.399.camel@haakon2.linux-iscsi.org>
	<337FFBD7-6B4A-41CA-BB57-6038C935B5BF@bootc.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 13 Chris Boot wrote:
> I'd like to support ABORT_TASK and friends at some point. The problem
> I see here though is that tags in SBP-2/3 are 48-bits wide (the ORB
> address in the initiator node's memory), and the target framework seems
> to use a u32 for this. SAM-3 Section 4.11 seems to say "A task tag is a
> value that is composed of up to 64 bits" so it might be worth getting
> that changed in the target framework?

In practice, its is quite likely that only 32 bit wide SBP tags are being
used.  But there is no way to guarantee this.
-- 
Stefan Richter
-=====-===-- --=- -==-=
http://arcgraph.de/sr/
