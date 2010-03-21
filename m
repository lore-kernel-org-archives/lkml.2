Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab0CUJTV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 05:19:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab0CUJTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 05:19:19 -0400
Message-ID: <4BA5E493.9050108@redhat.com>
Date: Sun, 21 Mar 2010 11:19:15 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@dtor-ws.eng.vmware.com>
CC: Dmitry Torokhov <dtor@vmware.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
       Alok Kataria <akataria@vmware.com>,
       Shaileshkumar Jain <sajain@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 4/4] Add VMware memory balloon driver
References: <20100319204628.4418.84674.stgit@localhost.localdomain> <20100319204702.4418.92437.stgit@localhost.localdomain> <4BA4C961.9060006@redhat.com> <20100320195359.GA11536@dtor-ws.eng.vmware.com>
In-Reply-To: <20100320195359.GA11536@dtor-ws.eng.vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2010 09:54 PM, Dmitry Torokhov wrote:
>> So while I'd love to see other hypervisors adopt virtio, I think in this
>> case it makes more sense to have your own balloon driver.
>>
>>      
> Fair enough. If this is a common sentiment we'll gladly prepare our
> standalone driver for submission.
>    

It's also possible to split out a "balloon core" that can be shared.  In 
this case it isn't worth it however as there any user visible interfaces 
and the shared code would amount to couple dozen lines or so.

-- 
error compiling committee.c: too many arguments to function

