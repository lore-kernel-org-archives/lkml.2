Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab1F3EVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 00:21:01 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:2250 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712Ab1F3EUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 00:20:53 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Message-ID: <4E0BF998.7030800@broadcom.com>
Date: Wed, 29 Jun 2011 21:20:40 -0700
From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17)
 Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
cc: "David Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Vladislav Zolotarov" <vladz@broadcom.com>,
        "James Bottomley" <James.Bottomley@HansenPartnership.com>,
        mchan@broadcom.com
Subject: Re: linux-next: manual merge of the net tree with the scsi tree
References: <20110630123325.43268067.sfr@canb.auug.org.au>
In-Reply-To: <20110630123325.43268067.sfr@canb.auug.org.au>
X-WSS-ID: 6215252762O16499944-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/29/2011 7:33 PM, Stephen Rothwell wrote:
> Hi all,
>
> Today's linux-next merge of the net tree got conflicts in
> drivers/scsi/bnx2fc/bnx2fc.h and drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> between commit 2382d2364a60 ("[SCSI] bnx2fc: Bumped version to 1.0.2")
> from the scsi tree and commit 619c5cb6885b ("New 7.0 FW: bnx2x, cnic,
> bnx2i, bnx2fc") from the net tree.
>
> I used the versions from the net tree as those version numbers were newer.
>
Stephen, can you please send the conflicts? Most probably you should 
have seen the conflicts w.r.t version number in bnx2fc.h and date in 
bnx2fc_fcoe.c.  If that is the case, the versions from net tree are good.

Thanks,
Bhanu


