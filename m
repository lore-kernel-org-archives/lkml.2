Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab1HQNmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 09:42:49 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:3521 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699Ab1HQNmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 09:42:45 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Subject: Re: [PATCH V2 net-next 2/3] bnx2x: Coalesce pr_cont uses and
 fix DP typos
From: "Eilon Greenstein" <eilong@broadcom.com>
Reply-to: eilong@broadcom.com
To: "Joe Perches" <joe@perches.com>
cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <88e0b7cd0aa9fdb34acae665d8bc235f8aa33ddf.1313360100.git.joe@perches.com>
References: <cover.1313360100.git.joe@perches.com>
 <88e0b7cd0aa9fdb34acae665d8bc235f8aa33ddf.1313360100.git.joe@perches.com>
Organization: Broadcom
Date: Wed, 17 Aug 2011 16:42:25 +0300
Message-ID: <1313588545.7266.8.camel@lb-tlvb-eilong.il.broadcom.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3
X-WSS-ID: 6255192D3DK12076721-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-08-14 at 15:16 -0700, Joe Perches wrote:
> Uses of pr_cont should be avoided where reasonably possible
> because they can be interleaved by other threads and processes.
> 
> Coalesce pr_cont uses.
> 
> Fix typos, duplicated words and spacing in DP uses caused
> by split multi-line formats.  Coalesce some of these
> split formats.  Add missing terminating newlines to DP uses.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Eilon Greenstein <eilong@broadcom.com>




