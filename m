Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab0JRM2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 08:28:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188Ab0JRM2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 08:28:16 -0400
Message-ID: <4CBC3DAC.4090100@redhat.com>
Date: Mon, 18 Oct 2010 08:29:32 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Lukas Czerner <lczerner@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, Eric Sandeen <esandeen@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Discard benchmarking tool for SSD's and thinly provisioned devices
References: <alpine.LFD.2.00.1010181247330.6517@dhcp-lab-213.englab.brq.redhat.com>	 <alpine.LFD.2.00.1010181336130.6517@dhcp-lab-213.englab.brq.redhat.com> <1287402474.29097.1551.camel@twins>
In-Reply-To: <1287402474.29097.1551.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/18/2010 07:47 AM, Peter Zijlstra wrote:
> On Mon, 2010-10-18 at 13:40 +0200, Lukas Czerner wrote:
>> Also note that there might be some devices with buggy firmware which may
>> be damaged beyond repair by the TRIM command, especially with TRIM
>> performed in random IO pattern (from first-hand experience).
> A list of known bad devices might be appreciated..

The challenge with naming devices that had issues is that some of them were 
early versions (not stable firmware) and some we got under NDA so we cannot name 
them...

ric

