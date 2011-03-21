Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab1CUQFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 12:05:54 -0400
Received: from mxout1.idt.com ([157.165.5.25]:58418 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734Ab1CUQFv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 12:05:51 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch] rapidio: potential null deref on failure path
Date: Mon, 21 Mar 2011 09:05:37 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E55201A589DA@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <20110321153609.GR2008@bicker>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] rapidio: potential null deref on failure path
Thread-Index: Acvn4TrZNXYtzdG5TRmUA9wsHTkSiQAAIdZg
References: <20110319044032.GC2008@bicker> <0CE8B6BE3C4AD74AB97D9D29BD24E55201A588F5@CORPEXCH1.na.ads.idt.com> <20110321145948.GP2008@bicker> <0CE8B6BE3C4AD74AB97D9D29BD24E55201A5897F@CORPEXCH1.na.ads.idt.com> <20110321153609.GR2008@bicker>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Dan Carpenter" <error27@gmail.com>
Cc: "Matt Porter" <mporter@kernel.crashing.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No problem.

-----Original Message-----
From: Dan Carpenter [mailto:error27@gmail.com] 
Sent: Monday, March 21, 2011 11:52 AM
To: Bounine, Alexandre
Cc: Matt Porter; linux-kernel@vger.kernel.org;
kernel-janitors@vger.kernel.org
Subject: Re: [patch] rapidio: potential null deref on failure path

On Mon, Mar 21, 2011 at 08:15:33AM -0700, Bounine, Alexandre wrote:
> In this case I agree. 
> Do you want me to move this patch up or you have your own path for it?
> 

Could you take it, please? 

regards,
dan carpenter


