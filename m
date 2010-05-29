Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab0E2XD1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 19:03:27 -0400
Received: from crca.org.au ([74.207.252.120]:54477 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756827Ab0E2XD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 19:03:26 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C019D36.8070405@crca.org.au>
Date: Sun, 30 May 2010 09:03:18 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: markgross@thegnar.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [patch] complain when users abuse the pm_qos API
References: <20100529045027.GE11600@gvim.org> <201005292208.04309.rjw@sisk.pl>
In-Reply-To: <201005292208.04309.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 30/05/10 06:08, Rafael J. Wysocki wrote:
> On Saturday 29 May 2010, mark gross wrote:
>> The following patch is to help clean up API abusers of pm_qos where
>> they call update_request before registering a request.
>>
>> --mgross
>>
>> --Signed-off-by: markgross<markgross@thegnar.org>
>
> Will there be a big issue if I push this during the next merge window?

What's the point to the patch? That is: why is calling update_request 
before registering a request such a big problem that it demands a WARN() 
and dump stack?

Regards,

Nigel
