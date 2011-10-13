Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab1JMUEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 16:04:00 -0400
Received: from smtp-1.sys.kth.se ([130.237.32.175]:44066 "EHLO
	smtp-1.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab1JMUD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 16:03:58 -0400
X-KTH-Auth: niso [89.253.77.162]
X-KTH-mail-from: niso@kth.se
Message-ID: <4E97442A.80308@kth.se>
Date: Thu, 13 Oct 2011 22:03:54 +0200
From: =?ISO-8859-1?Q?Niklas_S=F6derlund?= <niso@kth.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111001 Thunderbird/7.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "mchehab@redhat.com" <mchehab@redhat.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i7core_edac: fix erroneous size of static array
References: <1318530294-6829-1-git-send-email-niso@kth.se> <20111013185656.GC3064@aftab>
In-Reply-To: <20111013185656.GC3064@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2011 08:56 PM, Borislav Petkov wrote:

> On Thu, Oct 13, 2011 at 02:24:54PM -0400, Niklas Söderlund wrote:
>> Signed-off-by: Niklas Söderlund <niso@kth.se>
>> ---
>>  drivers/edac/i7core_edac.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
>> index 70ad892..e0f6096 100644
>> --- a/drivers/edac/i7core_edac.c
>> +++ b/drivers/edac/i7core_edac.c
>> @@ -441,7 +441,7 @@ static inline int numrow(u32 row)
>>  
>>  static inline int numcol(u32 col)
>>  {
>> -	static int cols[8] = {
>> +	static int cols[4] = {
>>  		1 << 10, 1 << 11, 1 << 12, -EINVAL,
>>  	};
> 
> Even better,
> 
> you could completely remove the number in the [] since the {}
> initializer contains all array elements already. In this and the
> remaining arrays in those small inline functions.
> 


Thanks for the feedback!

What would be the correct way of submitting an updated patch? Sending it
in this mail thread or create a new one?

// Niklas
