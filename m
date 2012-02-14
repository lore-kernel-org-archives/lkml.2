Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760697Ab2BNUCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 15:02:32 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:33331 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab2BNUC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 15:02:29 -0500
Message-ID: <4F3ABDD2.4000207@hp.com>
Date: Tue, 14 Feb 2012 12:02:26 -0800
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.26) Gecko/20120131 Lightning/1.0b2 Thunderbird/3.1.18
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Divy Le Ray <divy@chelsio.com>, David Woodhouse <dwmw2@infradead.org>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>,
        nhorman@tuxdriver.com
Subject: Re: [patch net-next] cxgb3: update firmware version
References: <20120213202846.631.30806.stgit@speedy5.asicdesigners.com> <1329165817.2092.62.camel@shinybook.infradead.org> <4F398303.1030606@chelsio.com> <1329184754.3048.33.camel@deadeye> <4F39E7C9.20901@chelsio.com> <1329196116.3048.66.camel@deadeye> <4F39F75D.6030107@chelsio.com> <4F3AA537.4050700@hp.com> <20120214182110.GO12704@decadent.org.uk>
In-Reply-To: <20120214182110.GO12704@decadent.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2012 10:21 AM, Ben Hutchings wrote:
> On Tue, Feb 14, 2012 at 10:17:27AM -0800, Rick Jones wrote:
>> What does an end-user/customer see and do?  When they are told that
>> version the firmware, specified down to the fix level, fixes a
>> problem they are having, how will they know that firmware blob
>> filename drvfw-X.bin on a download/archive site has that fix?
> [...]
>
> Customers currently can't get bug fixes by updating the firmware.
> Think about it.

Because in this case at least the driver is requesting a specific 
filename down to the minor and micro level and a change in the filename 
requires a change in the driver?

#define FW_VERSION __stringify(FW_VERSION_MAJOR) "."                    \
         __stringify(FW_VERSION_MINOR) "." __stringify(FW_VERSION_MICRO)
#define FW_FNAME "cxgb3/t3fw-" FW_VERSION ".bin"

rather than the driver having logic to make it willing to accept later 
minor/micro changes by being more sophisticated in its specification of 
firmware file.
