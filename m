Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528Ab0DHHSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 03:18:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758449Ab0DHHSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 03:18:46 -0400
Message-ID: <4BBD832C.6010002@redhat.com>
Date: Thu, 08 Apr 2010 10:18:04 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Dmitry Torokhov <dtor@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "pv-drivers@vmware.com" <pv-drivers@vmware.com>
Subject: Re: [PATCH] VMware Balloon driver
References: <20100404215202.GA13020@dtor-ws.eng.vmware.com> <20100405142419.2c9bea3d.akpm@linux-foundation.org> <20100405225833.GA25970@dtor-ws.eng.vmware.com> <4BBB622F.4070501@redhat.com> <4BBB7CA3.2060802@goop.org> <4BBB7F1E.3030307@redhat.com> <4BBB890E.5040808@goop.org> <20100408053024.GA1472@ucw.cz>
In-Reply-To: <20100408053024.GA1472@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2010 08:30 AM, Pavel Machek wrote:
> Hi!
>
>    
>>>> 1) is not a huge amount of code, but something consistent would be
>>>> nice.  2) is something we've been missing and is a bit of an open
>>>> question/research project anyway.
>>>>          
>>> 3) Code that attempts to reclaim 2MB pages when possible
>>>        
>> Yes.  Ballooning in 4k units is a bit silly.
>>      
> Does it make sense to treat ballooning as a form of memory hotplug?
>    

It's a fine granularity form of memory hotplug, yes.

-- 
error compiling committee.c: too many arguments to function

