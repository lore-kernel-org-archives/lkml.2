Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab0DTNye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 09:54:34 -0400
Received: from pmx3.lnl.infn.it ([192.135.30.243]:43537 "EHLO pmx3.lnl.infn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084Ab0DTNyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 09:54:32 -0400
Message-ID: <6490876.1271771620997.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
Date: Tue, 20 Apr 2010 15:53:40 +0200 (CEST)
From: Andrea Gozzelino <Andrea.Gozzelino@lnl.infn.it>
To: Amir Vadai <amirv@mellanox.co.il>
Subject: Re: Socket Direct Protocol: help (2)
Cc: "Tung, Chien Tin" <chien.tin.tung@intel.com>,
       Steve Wise <swise@opengridcomputing.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
       "rolandd@cisco.com" <rolandd@cisco.com>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "pavel@ucw.cz" <pavel@ucw.cz>, "mingo@elte.hu" <mingo@elte.hu>,
       Eric B Munson <ebmunson@us.ibm.com>
In-Reply-To: <4BC6D075.1070405@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Priority: 2 (high)
X-Mailer: SuSE Linux Openexchange Server 4 - WebMail (Build 2.4160)
X-Operating-System: Linux 2.4.21-314-smp i386 (JVM 1.3.1_20)
Organization: INFN - Laboratori Nazionali Legnaro
References: <13381_1271060138_o3C8FUH8013968_2977669.1271060085255.SLOX.WebMail.wwwrun@imap.lnl.infn.it> <1246722.1271082830120.SLOX.WebMail.wwwrun@imap.lnl.infn.it> <2EFBCAEF10980645BBCFB605689E08E9047C7402DA@azsmsx506.amr.corp.intel.com> <4BC49E2B.3000804@opengridcomputing.com> <2EFBCAEF10980645BBCFB605689E08E9047C7405A0@azsmsx506.amr.corp.intel.com> <4BC4D22A.6020700@opengridcomputing.com> <2EFBCAEF10980645BBCFB605689E08E9047C7405E9@azsmsx506.amr.corp.intel.com> <7037536.1271235105513.SLOX.WebMail.wwwrun@imap.lnl.infn.it> <4BC5D1D3.3020004@mellanox.co.il> <4BC5D529.1060701@mellanox.co.il> <2EFBCAEF10980645BBCFB605689E08E9047C79B918@azsmsx506.amr.corp.intel.com> <4BC5D9D4.7020702@opengridcomputing.com> <2EFBCAEF10980645BBCFB605689E08E9047C79BD12@azsmsx506.amr.corp.intel.com> <4BC6B135.2060004@mellanox.co.il> <1205877.1271315264088.SLOX.WebMail.wwwrun@imap.lnl.infn.it> <4BC6D075.1070405@mellanox.co.il>
X-PMX-Version: 5.5.9.395186, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.4.20.134222 (i)
X-Spam-Flag: NO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amir,

have you any news about bugs 2027 "SDP not respecting # SGEs as reported
from HW" and 2028 "SDP should support fastreg mrs"?

When those bugs will be fixed, I will test the NE020 cards performance
with SDP protocol and I will compare SDP and TCP.

Keep in touch,

Andrea Gozzelino

INFN - Laboratori Nazionali di Legnaro	(LNL)
Viale dell'Universita' 2
I-35020 - Legnaro (PD)- ITALIA
Tel: +39 049 8068346
Fax: +39 049 641925
Mail: andrea.gozzelino@lnl.infn.it







On Apr 15, 2010 10:38 AM, Amir Vadai <amirv@mellanox.co.il> wrote:

> It should be a simple fix and I plan to do soon - just add yourself as
> CC in bugzilla  - that way I won't forget to notify you.
> 
> - amir
> 
> On 04/15/2010 10:07 AM, Andrea Gozzelino wrote:
> > On Apr 15, 2010 08:24 AM, Amir Vadai <amirv@mellanox.co.il> wrote:
> >
> >   
> >> I hope to have a fix next week for the first one.
> >>
> >> Thanks,
> >> Amir
> >>
> >> On 04/14/2010 09:48 PM, Tung, Chien Tin wrote:
> >>     
> >>>> Tung, Chien Tin wrote:
> >>>>     
> >>>>         
> >>>>>> One more thing - Please open a bug regarding the num_sge
> >>>>>> limitation at:
> >>>>>> https://bugs.openfabrics.org/
> >>>>>>
> >>>>>>         
> >>>>>>             
> >>>>> Done, Bug 2027.
> >>>>>
> >>>>> Chien
> >>>>>
> >>>>>       
> >>>>>           
> >>>> And 2028 opened to request fastreg support.
> >>>>
> >>>>     
> >>>>         
> >>> I am open to test fixes for these two bugs.
> >>>
> >>> Chien
> >>>
> >>>   
> >>>       
> >>     
> > Hi Amir, 
> > Hi Chien,
> >
> > I understand that the bug 2027 could be solved next week, so I will
> > test
> > SDP protocol performance on NE020 cards.
> > Is it correct? 
> > If yes, could you point out the code modifies?
> >
> > Keep in touch and take care.
> > Regards,
> > Andrea
> >
> >
> > Andrea Gozzelino
> >
> > INFN - Laboratori Nazionali di Legnaro	(LNL)
> > Viale dell'Universita' 2
> > I-35020 - Legnaro (PD)- ITALIA
> > Tel: +39 049 8068346
> > Fax: +39 049 641925
> > Mail: andrea.gozzelino@lnl.infn.it			
> >
> >
> >   
> 


		

