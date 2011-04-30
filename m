Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201Ab1D3U2z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 16:28:55 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:41282 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab1D3U2y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 16:28:54 -0400
From: KY Srinivasan <kys@microsoft.com>
To: root <root@docs.homelinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Error in Hyper-V modules hv_vmbus
Thread-Topic: Error in Hyper-V modules hv_vmbus
Thread-Index: AQHMB0SgETUemc5uTUuEnNLkft8sE5R22q3w
Date: Sat, 30 Apr 2011 20:28:52 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481DF19C@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <4DBC1F2F.5050205@docs.homelinux.org>
In-Reply-To: <4DBC1F2F.5050205@docs.homelinux.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: root [mailto:root@docs.homelinux.org]
> Sent: Saturday, April 30, 2011 10:40 AM
> To: linux-kernel@vger.kernel.org; KY Srinivasan
> Subject: Error in Hyper-V modules hv_vmbus
> 
> Hello
> 
> I have compiled and installed the new 2.6.39-rc5 linux kernel with
> Microsoft Hyper-V modules enabled on my Debian Squeeze system. After a
> reboot I get these errors (sorry can post only screenshots because I
> can't copy the log):

What is the version of the Windows host. I have seen some issues with
older hosts, where the vmbus driver does not get the correct irq. I have 
submitted a patch for this (this is yet to be applied by Greg).

Regards,

K. Y

