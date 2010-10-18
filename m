Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab0JROxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:53:24 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51083 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab0JROxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:53:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=f/ZC0g5DomLdRT2nglbHpAem+yKtePRLM1r6FXj+bho2vcmaVm6+hjP90ifz3WOtMK
         7CBwSSOFl3cjE9ioPbcbxd3X+otcUpgcDEQARR+IgWnqpOHKIgcjvwMrowUtFj0QyLJ4
         nc20a6T2jHrsrm1sMpgFBHMuvypfVL2JC+Kxw=
Subject: Re: [PATCH] ext3: Remove misplaced BUFFER_TRACE() in
 ext3_truncate()
From: Namhyung Kim <namhyung@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4CBC5825.8050502@redhat.com>
References: <1287140582-5925-1-git-send-email-namhyung@gmail.com>
	 <4CBC5825.8050502@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 23:53:11 +0900
Message-ID: <1287413591.1689.25.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-10-18 (월), 09:22 -0500, Eric Sandeen:
> As long as you're doing these cleanups, you may as well eyeball ext4
> to see whether the same issues exist; in the case above, it does, and the
> exact same patch (modulo ext3/ext4 changes) applies.
> 
> No real point in getting ext3 fixed up and leaving ext4 behind...
> 

My plan was sending those patches in a batch after reading ext3 at all.
But it seems to take some time, so now I think that it'd be better to
send them in a small series. I'll prepare it for ext4 (and ext2 too if
you want, Jan) soon. Thanks.

-- 
Regards,
Namhyung Kim


