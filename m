Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab1EAPXT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 11:23:19 -0400
Received: from mailb.microsoft.com ([131.107.115.215]:20659 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab1EAPXR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 11:23:17 -0400
From: KY Srinivasan <kys@microsoft.com>
To: root <root@docs.homelinux.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Error in Hyper-V modules hv_vmbus
Thread-Topic: Error in Hyper-V modules hv_vmbus
Thread-Index: AQHMB0SgETUemc5uTUuEnNLkft8sE5R22q3wgAGFHAD//7Zr8A==
Date: Sun, 1 May 2011 15:23:16 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481DF22B@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <4DBC1F2F.5050205@docs.homelinux.org>
 <6E21E5352C11B742B20C142EB499E0481DF19C@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <4DBD53F6.6070603@docs.homelinux.org>
In-Reply-To: <4DBD53F6.6070603@docs.homelinux.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: root [mailto:root@docs.homelinux.org]
> Sent: Sunday, May 01, 2011 8:37 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: Error in Hyper-V modules hv_vmbus
> 
> 
> >
> >> -----Original Message-----
> >> From: root [mailto:root@docs.homelinux.org]
> >> Sent: Saturday, April 30, 2011 10:40 AM
> >> To: linux-kernel@vger.kernel.org; KY Srinivasan
> >> Subject: Error in Hyper-V modules hv_vmbus
> >>
> >> Hello
> >>
> >> I have compiled and installed the new 2.6.39-rc5 linux kernel with
> >> Microsoft Hyper-V modules enabled on my Debian Squeeze system. After a
> >> reboot I get these errors (sorry can post only screenshots because I
> >> can't copy the log):
> > What is the version of the Windows host. I have seen some issues with
> > older hosts, where the vmbus driver does not get the correct irq. I have
> > submitted a patch for this (this is yet to be applied by Greg).
> >
> > Regards,
> >
> > K. Y
> >
> 
> Windows Server Core 2008 R2 with SP2
Thank you. I will get back to you after some testing locally.
I have already submitted a patch for dealing with irq allocation 
on some windows hosts (yet to be applied). I will verify if this patch fixes your problem. 

Regards,

K. Y

> 
> Regards
> Juan Dos Santos

