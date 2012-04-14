Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab2DNXMQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 19:12:16 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38799 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab2DNXMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 19:12:14 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 15 Apr 2012 01:11:51 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Chris Boot <bootc@bootc.net>, linux1394-devel@lists.sourceforge.net,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        agrover@redhat.com, clemens@ladisch.de
Subject: Re: [PATCH 0/2] sbp-target: cleanup after merge into single file
Message-ID: <20120415011151.55d14826@stein>
In-Reply-To: <1334439895.12540.65.camel@haakon2.linux-iscsi.org>
References: <1334366583.12540.12.camel@haakon2.linux-iscsi.org>
	<1334394746-31738-1-git-send-email-bootc@bootc.net>
	<1334439895.12540.65.camel@haakon2.linux-iscsi.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 14 Nicholas A. Bellinger wrote:
> Also, it looks like Stefan has a few more comments from the last round
> of review..

Don't consider them blocking.  I would welcome it if the code gets merged
soon, it looks very nice and maintainable.  The card state <-> session
state interactions which I was wondering about will be more comfortable for
me to investigate when it is in mainline; I believe there is no urgency
for me to look into that.  Other obscure but simple things like making use
of memory alignment guarantees from firewire-core are more effectively
addressed if I can send patches rather than comments.
-- 
Stefan Richter
-=====-===-- -=-- -====
http://arcgraph.de/sr/
