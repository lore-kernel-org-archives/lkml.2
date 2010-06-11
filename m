Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab0FKFBO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 01:01:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491Ab0FKFBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 01:01:13 -0400
Message-ID: <4C11C309.8030304@redhat.com>
Date: Fri, 11 Jun 2010 08:00:57 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Andrea Arcangeli <aarcange@redhat.com>, Izik Eidus <ieidus@redhat.com>,
       Chris Wright <chrisw@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ksm: cleanup for mm_slots_hash
References: <4BFF66CC.4050204@cn.fujitsu.com> <4C104CBE.8060404@cn.fujitsu.com> <20100610220328.GV28052@random.random>
In-Reply-To: <20100610220328.GV28052@random.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2010 01:03 AM, Andrea Arcangeli wrote:
> Hi Lai,
>
> On Thu, Jun 10, 2010 at 10:23:58AM +0800, Lai Jiangshan wrote:
>    
>> Hi, Izik
>>
>> Could you give some comments about this patch.
>>      
> I just talked with Izik and he agrees with patch! ;)
>
>    

Note, to get the patch merged your best bet is to copy linux-mm and 
Andrew Morton.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

