Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab1AaR7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 12:59:44 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:57757
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752227Ab1AaR7n convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 12:59:43 -0500
X-SpamScore: -40
X-BigFish: VPS-40(zz601IL542N1432N9371Pzz1202hzz8275dhz2dh95h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 3/3 RFC] dt: add documentation of ARM dt boot interface
Date: Mon, 31 Jan 2011 10:00:03 -0800
In-Reply-To: <20110131074510.9058.59071.stgit@localhost6.localdomain6>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/3 RFC] dt: add documentation of ARM dt boot interface
Thread-Index: AcvBGwUlQXts1T8ATpS9yWj1FfyL9QAVUiDg
References: <20110131073918.9058.37628.stgit@localhost6.localdomain6> <20110131074510.9058.59071.stgit@localhost6.localdomain6>
From: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        <devicetree-discuss@lists.ozlabs.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
CC: <sam@ravnborg.org>
X-OriginalArrivalTime: 31 Jan 2011 17:59:35.0977 (UTC) FILETIME=[9F16F190:01CBC170]
X-RCIS-Action: ALLOW
Message-ID: <44dc88e7-3086-4762-8789-f455f3b265ec@VA3EHSMHS027.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linuxppc-dev-bounces+stephen=neuendorffer.name@lists.ozlabs.org
[mailto:linuxppc-dev-
> bounces+stephen=neuendorffer.name@lists.ozlabs.org] On Behalf Of Grant
Likely
> Sent: Sunday, January 30, 2011 11:46 PM
> To: devicetree-discuss@lists.ozlabs.org;
linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
> Cc: sam@ravnborg.org
> Subject: [PATCH 3/3 RFC] dt: add documentation of ARM dt boot
interface
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
> 
> For RFC only.  I do not plan to merge this change yet.
> 
> g.
> 
>  Documentation/devicetree/booting-without-of.txt |   40
+++++++++++++++++++++++
>  1 files changed, 40 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/devicetree/booting-without-of.txt
b/Documentation/devicetree/booting-
> without-of.txt
> index 6bca668..3950aea 100644
> --- a/Documentation/devicetree/booting-without-of.txt
> +++ b/Documentation/devicetree/booting-without-of.txt

In order to make this more generic, perhaps it should change names, so
that it is actually a description of what the file
describes, as opposed to what it doesn't describe.  "booting.txt"?

> @@ -13,6 +13,7 @@ Table of Contents
> 
>    I - Introduction
>      1) Entry point for arch/powerpc
> +    2) Entry point for arch/arm

We should probably include microblaze here too...

Steve

This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


