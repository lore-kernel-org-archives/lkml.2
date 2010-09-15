Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab0IOTNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 15:13:34 -0400
Received: from mail152.messagelabs.com ([216.82.253.19]:38746 "EHLO
	mail152.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081Ab0IOTNd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 15:13:33 -0400
X-VirusChecked: Checked
X-Env-Sender: tanderson@curtisswright.com
X-Msg-Ref: server-6.tower-152.messagelabs.com!1284578006!54924334!3
X-StarScan-Version: 6.2.4; banners=curtisswright.com,-,-
X-Originating-IP: [67.20.170.11]
From: "Anderson, Trevor" <tanderson@curtisswright.com>
To: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Moll <thomas.moll@sysgo.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Date: Wed, 15 Sep 2010 15:13:27 -0400
Subject: RE: [PATCH v2 09/10] RapidIO: Add support for IDT CPS Gen2 switches
Thread-Topic: [PATCH v2 09/10] RapidIO: Add support for IDT CPS Gen2 switches
Thread-Index: ActUWruG03q/83K1SHqhkR/gwuIGNQAh6CIwAAgVINAAARR9cAAAlzCQ
Message-ID: <1682399277683944B902B3657D2FCE216544F4A20D@CAREXCLUSTER03.ATL.CW.LOCAL>
References: <1284476363-1677-1-git-send-email-alexandre.bounine@idt.com><1284476363-1677-10-git-send-email-alexandre.bounine@idt.com><20100914152049.8d42783f.akpm@linux-foundation.org>
 <0CE8B6BE3C4AD74AB97D9D29BD24E5520130321F@CORPEXCH1.na.ads.idt.com>
 <1682399277683944B902B3657D2FCE216544F4A1F0@CAREXCLUSTER03.ATL.CW.LOCAL>
 <0CE8B6BE3C4AD74AB97D9D29BD24E5520130332B@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E5520130332B@CORPEXCH1.na.ads.idt.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Bounine, Alexandre [mailto:Alexandre.Bounine@idt.com]
> Sent: Wednesday, September 15, 2010 11:53 AM
> To: Anderson, Trevor; Andrew Morton
> Cc: linux-kernel@vger.kernel.org; Thomas Moll; linuxppc-dev@lists.ozlabs.org
> Subject: RE: [PATCH v2 09/10] RapidIO: Add support for IDT CPS Gen2 switches
>
> Anderson, Trevor <tanderson@curtisswright.com> wrote:
> >
> > Keep it in please. We lurkers in the embedded community do use the
> per-port routing tables.
> > One of the problems with SRIO switch tables is that access to routes
> is not atomic; we can use
> > restricted access to per-port routing tables to reduce the risk of
> interference. And we still use
> > the Global table during enumeration.
> >
> Will it help if I add sysfs attribute(s) to handle per-port routes?

I don't think so - not from my perspective, at least. All of our routes
are programmed using the broadcast table; but we use the private tables
as a safer method of reading the routes that have been programmed, when we
need to know that.



_______________________________________________________________________
This e-mail and any files transmitted with it are proprietary and intended solely for the use of the individual or entity to whom they are addressed. If you have reason to believe that you have received this e-mail in error, please notify the sender and destroy this email and any attached files. Please note that any views or opinions presented in this e-mail are solely those of the author and do not necessarily represent those of the Curtiss-Wright Corporation or any of its subsidiaries.  Documents attached hereto may contain technology subject to government export regulations. Recipient is solely responsible for ensuring that any re-export, transfer or disclosure of this information is in accordance with applicable government export regulations.  The recipient should check this e-mail and any attachments for the presence of viruses. Curtiss-Wright Corporation and its subsidiaries accept no liability for any damage caused by any virus transmitted by this e-mail.
