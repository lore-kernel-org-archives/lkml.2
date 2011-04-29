Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934057Ab1D2Ww0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 18:52:26 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:47640 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934030Ab1D2WwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 18:52:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=lRvicHOOp53mKRinIKp1hvoQmw5oo0ZCEcz7DY/M1IFwYq1t3S/Q31TIdR24vV/DQ54Dti60IyfRpYdm+1ZoV53zF2t+qcFX9Xea3T5YGowVgJ0IiGNqCHT8Tk2CalgE;
Date: Fri, 29 Apr 2011 15:52:21 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: <pefoley2@verizon.net>
Cc: <linux-kernel@vger.kernel.org>, <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH V2 7/7] kbuild: move docproc from scripts/basic to
 scripts
Message-Id: <20110429155221.64e437d7.rdunlap@xenotime.net>
In-Reply-To: <4DBB3DED.1060508@verizon.net>
References: <4DBB3DED.1060508@verizon.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Apr 2011 18:38:37 -0400 Peter Foley wrote:

> This patch moves docproc from scripts/basic to scripts.
> 
> Signed-off-by: Peter Foley <pefoley2@verizon.net>
> ---
>  scripts/{basic => }/docproc.c |    0
>  1 files changed, 0 insertions(+), 0 deletions(-)
>  rename scripts/{basic => }/docproc.c (100%)
> 
> diff --git a/scripts/basic/docproc.c b/scripts/docproc.c
> similarity index 100%
> rename from scripts/basic/docproc.c
> rename to scripts/docproc.c
> -- 


patch -p1 -bs --dry-run  < ~/0007-kbuild-move-docproc-from-scripts-basic-to-scripts.patch 
patch: **** Only garbage was found in the patch input.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
