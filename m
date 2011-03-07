Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab1CGXys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 18:54:48 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:3179 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab1CGXyr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 18:54:47 -0500
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Subject: Re: [PATCH] [SCSI] bnx2fc: fix build error when !CONFIG_MODULES
From: "Bhanu Gollapudi" <bprakash@broadcom.com>
To: "Mariusz Kozlowski" <mk@lab.zgora.pl>
cc: "Stephen Rothwell" <sfr@canb.auug.org.au>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
In-Reply-To: <20110307201610.GA9032@mako-laptop>
References: <20110302182740.e4dfd79f.sfr@canb.auug.org.au>
 <1299103803-32594-1-git-send-email-mk@lab.zgora.pl>
 <20110307201610.GA9032@mako-laptop>
Date: Mon, 7 Mar 2011 15:54:35 -0800
Message-ID: <1299542075.5232.5.camel@LTSJC-BPRAKASH.corp.ad.broadcom.com>
MIME-Version: 1.0
X-WSS-ID: 616BAF5A3T83480993-01-01
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-07 at 12:16 -0800, Mariusz Kozlowski wrote: 
> On Wed, Mar 02, 2011 at 11:10:03PM +0100, Mariusz Kozlowski wrote:
> > drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1815: error: dereferencing pointer to incomplete type
> > drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1815: error: ‘MODULE_STATE_LIVE’ undeclared (first use in this function)
> 
> Hm. Still there in next-20110307. Is this patch wrong or..?
> 

James,

Here is my ack for this patch.

Thanks,
Bhanu


