Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab0I1Rvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 13:51:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54932 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754951Ab0I1Rvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 13:51:42 -0400
Message-ID: <4CA22B20.5040800@zytor.com>
Date: Tue, 28 Sep 2010 10:51:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Conny Seidel <conny.seidel@amd.com>
CC: Jan Beulich <JBeulich@novell.com>,
        "borislav.petkov" <borislav.petkov@amd.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "mingo@elte.hu" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: current TIP/master doesn't build on SLES10
References: <20100928163136.7a2355d0@marah.osrc.amd.com>	<4CA22F1D020000780001961F@vpn.id2.novell.com> <20100928191428.7696d681@marah.osrc.amd.com>
In-Reply-To: <20100928191428.7696d681@marah.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2010 10:14 AM, Conny Seidel wrote:
>>>
>>> I've bisected it to commit df5d1874ce1a1f0e0eceff4fa3a9d45620243a68.
>>>
>>> Reverting it fixes the issue.
>>>
>>> I know that this is caused by binutils 2.16.91.0.5 which is distributed
>>> with SLES10.
>>
>> I'm generally doing almost all of my work on SLE10, and have not run
>> into this issue. Are you sure you've got it fully updated?
>>
>> Jan
> 
> Just for the record:
> The binutils from SLES10 SP3 (2.16.91.0.5-23.34.33) have fixed the build
> issue for me.
> 

OK, thanks for confirming that.  Presumably it contains a backport of
some fix.

	-hpa
	
