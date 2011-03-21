Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab1CUO6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 10:58:19 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:56391 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab1CUO6R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 10:58:17 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: Haiyang Zhang <haiyangz@microsoft.com>, Greg KH <gregkh@suse.de>,
        "Olaf Hering" <olaf@aepfle.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] hv: use sync_bitops when interacting with the hypervisor
Thread-Topic: [PATCH] hv: use sync_bitops when interacting with the
 hypervisor
Thread-Index: AQHL5827AryHuDVrIk+hbeQS3kp3ipQ4SOqAgAACD4D//5XoIA==
Date: Mon, 21 Mar 2011 14:58:15 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C56233FC96B2@TK5EX14MBXC118.redmond.corp.microsoft.com>
References: <20110321134137.GA29305@aepfle.de>
 <20110321140927.GA7358@suse.de>
 <A1F3067C9B68744AA19F6802BAB8FFDC087559@TK5EX14MBXC223.redmond.corp.microsoft.com>
In-Reply-To: <A1F3067C9B68744AA19F6802BAB8FFDC087559@TK5EX14MBXC223.redmond.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Haiyang Zhang
> Sent: Monday, March 21, 2011 7:17 AM
> To: Greg KH; Olaf Hering
> Cc: Hank Janssen; linux-kernel@vger.kernel.org
> Subject: RE: [PATCH] hv: use sync_bitops when interacting with the
> hypervisor
> > From: Greg KH [mailto:gregkh@suse.de]
> >
> > Great!  Can I get an Acked-by from Hank or Haiyang on this as well
> > before I apply it?
> 
> Our testing team has verified Olaf's fix.
> Thanks,
> 

Yep, it worked great.  Thank you Olaf for doing this!

Hank.

