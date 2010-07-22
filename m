Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab0GVFmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 01:42:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab0GVFmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 01:42:53 -0400
Message-ID: <4C47DA56.3010201@redhat.com>
Date: Thu, 22 Jul 2010 08:42:46 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Karl Rister <kmr@us.ibm.com>
Subject: Re: [RFC][PATCH 9/9] make kvm mmu shrinker more aggressive
References: <20100615135518.BC244431@kernel.beaverton.ibm.com>	 <20100615135530.4565745D@kernel.beaverton.ibm.com>	 <4C189830.2070300@redhat.com>  <1276701911.6437.16973.camel@nimitz>	 <1276876156.6437.23323.camel@nimitz>  <4C1DCD1A.4010306@redhat.com>	 <1277224359.9782.21.camel@nimitz>  <4C47CABC.1080801@redhat.com> <1279776987.9785.2030.camel@nimitz>
In-Reply-To: <1279776987.9785.2030.camel@nimitz>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2010 08:36 AM, Dave Hansen wrote:
>
>> Dave, how did those tests go?
>>      
> Still waiting on the folks that found this in the first place to
> reproduce it and see if the patches help.  I'll go nudge them some more.
>    

The merge window is coming up soon, and I'd like these patches to go in.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

