Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760011Ab0EDQm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 12:42:28 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55897 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759856Ab0EDQm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 12:42:26 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,5971"; a="40385997"
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
From: Daniel Walker <dwalker@codeaurora.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Russell King <rmk@arm.linux.org.uk>
In-Reply-To: <20100504110725.0b44d877.sfr@canb.auug.org.au>
References: <20100504110725.0b44d877.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 May 2010 09:42:13 -0700
Message-ID: <1272991333.4813.1.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-04 at 11:07 +1000, Stephen Rothwell wrote:
> Hi Daniel,
> 
> Today's linux-next merge of the msm tree got a conflict in
> arch/arm/mach-msm/Kconfig between commit
> 4b53eb4f5d78416456bb969ce30e3bed2731d744 ("arm: msm: allow ARCH_MSM to
> have v7 cpus") from the arm tree and commit
> e17047ea51cc2eac3e920e5a669f99efd44f446f ("arm: msm: smd: use either
> package v3 or v4 not both") from the msm tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Ok .. I'll merge the changes in Russell tree into my tree, that should
fix it I think.

Daniel

