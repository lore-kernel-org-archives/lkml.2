Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab2HZHsG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 03:48:06 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27872 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab2HZHsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 03:48:03 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6815"; a="229540828"
Date: Sun, 26 Aug 2012 00:48:02 -0700
From: David Brown <davidb@codeaurora.org>
To: Konstantin Ryabitsev <mricon@kernel.org>
Cc: ksummit-2012-discuss@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2012-discuss] Pubring and instructions for the KS 2012
 keysigning
Message-ID: <20120826074802.GB23985@codeaurora.org>
References: <50387307.9070001@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50387307.9070001@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 11:39:03PM -0700, Konstantin Ryabitsev wrote:

> 6. When you get back to your laptop, run "gpg --sign-key [keyid]" for
> all the people marked "X" on your worksheet. The key id is the last 8
> chars of the fingerprint smushed together. [***] If a person has
> multiple fingerprints, sign all their keys.

Well, this can be made to work, but it's a bit clumsy.  People will be
verifying their fingerprint against the sha of the keyring.  The pdf
file isn't trusted (although each person could verify it, if desired).

This means that each person I want to sign, I have to assure that
their signature matches the one in the signed keyring, and to make the
worksheet useful, I have to also verify that the fingerprint on the
worksheet matches.

Some may find it useful to print out the worksheet themselves along
with its hash, and we can verify the sha256 hash of the pdf file.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
