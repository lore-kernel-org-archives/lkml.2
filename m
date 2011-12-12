Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab1LLOxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 09:53:47 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:46666 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab1LLOxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 09:53:44 -0500
Date: Mon, 12 Dec 2011 10:53:30 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: pjones@redhat.com
Subject: Re-add ibft tree to linux-next please
Message-ID: <20111212145330.GA16278@andromeda.dapyr.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Stephen,

I've one patch for the iBFT and since I am the co-maintainer of said tree,
please add this tree to your awesome build system:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/ibft.git

The branch is "linux-next"

Signed-off-by: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: Peter Jones <pjones@redhat.com>
Thanks!

P.S.
After kernel.org went down, I choose not to resurface the iBFT tree b/c I
figured that the driver was sooo stable that there would be no need for any
patches. Well, not the case
