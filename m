Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab0DMUTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 16:19:48 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:35614 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753275Ab0DMUTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 16:19:46 -0400
Message-ID: <4BC4D22A.6020700@opengridcomputing.com>
Date: Tue, 13 Apr 2010 15:20:58 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: "Tung, Chien Tin" <chien.tin.tung@intel.com>
CC: Andrea Gozzelino <Andrea.Gozzelino@lnl.infn.it>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
       "rolandd@cisco.com" <rolandd@cisco.com>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "pavel@ucw.cz" <pavel@ucw.cz>, "mingo@elte.hu" <mingo@elte.hu>,
       Eric B Munson <ebmunson@us.ibm.com>
Subject: Re: Socket Direct Protocol: help (2)
References: <13381_1271060138_o3C8FUH8013968_2977669.1271060085255.SLOX.WebMail.wwwrun@imap.lnl.infn.it> <1246722.1271082830120.SLOX.WebMail.wwwrun@imap.lnl.infn.it> <2EFBCAEF10980645BBCFB605689E08E9047C7402DA@azsmsx506.amr.corp.intel.com> <4BC49E2B.3000804@opengridcomputing.com> <2EFBCAEF10980645BBCFB605689E08E9047C7405A0@azsmsx506.amr.corp.intel.com>
In-Reply-To: <2EFBCAEF10980645BBCFB605689E08E9047C7405A0@azsmsx506.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tung, Chien Tin wrote:
>>> NE020 supports 4 SGEs.  I don't know enough about SDP to know why it is
>>> using this calculation for # of send_sge:
>>>
>>> #define SDP_MAX_RECV_SKB_FRAGS (PAGE_SIZE > 0x8000 ? 1 : 0x8000 / PAGE_SIZE)
>>>
>>>
>>>       
>> Chien, does the NE020 support FMRs?  I looked at the nes ofed-1.5 code
>> and it appears to do nothing in the map_phys_fmr functions.
>>     
>
> We never implemented map_phys_fmr.  Is it relevant to the # of SGEs?
>   
No, but SDP uses FMRs.  I don't think it will run without FMR support.


