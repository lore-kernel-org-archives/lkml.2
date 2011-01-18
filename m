Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471Ab1ARMdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 07:33:32 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48412 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab1ARMda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 07:33:30 -0500
Message-Id: <20110118123233.712697250@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Tue, 18 Jan 2011 13:32:33 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: dave@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/4] read-only remount fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al,

Here's a patchset that fixes a read-only remount race.  Could you
please add it to your vfs tree?

Updated to apply against latest -git (e6f597a142).

Thanks,
Miklos
