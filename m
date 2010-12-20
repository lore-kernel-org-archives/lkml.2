Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076Ab0LTTdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 14:33:43 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:35503 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932744Ab0LTTdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 14:33:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=wW8pCRAr1YREUcbo/NhD2A0JOUG2VqSDaDIpyFJK//J7fhe73CiHZ3GMTZJ2bm0zZY
         dDcmjbpu8HVhbMK1i1bct2nmT/FC+4ZJPN919apthLYNCWPJoSIel5P19RGJn8ny2oUB
         23MBoGOlasqOGpgTj4YV6CY151yna2jF8UEiA=
MIME-Version: 1.0
In-Reply-To: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
Date: Mon, 20 Dec 2010 11:33:40 -0800
Message-ID: <AANLkTi=+QhTdWFEtu9UD9AJC_N+UET8i+7F_qzOS5Znt@mail.gmail.com>
Subject: Re: [PATCH 00/12] LLD host_lock-less conversion status for .38
From: adam radford <aradford@gmail.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@suse.de>,
        Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@lst.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>,
        Mike Anderson <andmike@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Ravi Anand <ravi.anand@qlogic.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Kashyap Desai <Kashyap.Desai@lsi.com>,
        MPTFusionLinux <DL-MPTFusionLinux@lsi.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 19, 2010 at 1:21 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> *) megaraid_sas: Running in host_lock-less mode with MSI-X interrupts
>
> This has not been tested yet, but I would like to get some review from the LSI
> megaraid_sas folks now that their patches to enable MSI-X interrupts has been sent
> to linux-scsi.
>
> AdamR, any thoughts or comments to add here..?

Nick,

Your patch will not work with the new MegaRAID adapter support I have
sent in recently.  It requires the build IO path be synchronized with
map updates with the host_lock.

-Adam
