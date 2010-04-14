Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab0DNPEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 11:04:42 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:41420 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755744Ab0DNPEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 11:04:40 -0400
Message-ID: <4BC5D9D4.7020702@opengridcomputing.com>
Date: Wed, 14 Apr 2010 10:05:56 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: "Tung, Chien Tin" <chien.tin.tung@intel.com>
CC: Amir Vadai <amirv@mellanox.co.il>,
       Andrea Gozzelino <Andrea.Gozzelino@lnl.infn.it>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
       "rolandd@cisco.com" <rolandd@cisco.com>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "pavel@ucw.cz" <pavel@ucw.cz>, "mingo@elte.hu" <mingo@elte.hu>,
       Eric B Munson <ebmunson@us.ibm.com>
Subject: Re: Socket Direct Protocol: help (2)
References: <13381_1271060138_o3C8FUH8013968_2977669.1271060085255.SLOX.WebMail.wwwrun@imap.lnl.infn.it>	<1246722.1271082830120.SLOX.WebMail.wwwrun@imap.lnl.infn.it>	<2EFBCAEF10980645BBCFB605689E08E9047C7402DA@azsmsx506.amr.corp.intel.com>	<4BC49E2B.3000804@opengridcomputing.com>	<2EFBCAEF10980645BBCFB605689E08E9047C7405A0@azsmsx506.amr.corp.intel.com>	<4BC4D22A.6020700@opengridcomputing.com>	<2EFBCAEF10980645BBCFB605689E08E9047C7405E9@azsmsx506.amr.corp.intel.com>	<7037536.1271235105513.SLOX.WebMail.wwwrun@imap.lnl.infn.it>	<4BC5D1D3.3020004@mellanox.co.il> <4BC5D529.1060701@mellanox.co.il> <2EFBCAEF10980645BBCFB605689E08E9047C79B918@azsmsx506.amr.corp.intel.com>
In-Reply-To: <2EFBCAEF10980645BBCFB605689E08E9047C79B918@azsmsx506.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tung, Chien Tin wrote:
>> One more thing - Please open a bug regarding the num_sge limitation at:
>> https://bugs.openfabrics.org/
>>     
>
> Done, Bug 2027.
>
> Chien
>   

And 2028 opened to request fastreg support.

Steve.
