Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab2ECNlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 09:41:12 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:53970 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755426Ab2ECNlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 09:41:11 -0400
Message-ID: <4FA28AF4.1000205@boundarydevices.com>
Date: Thu, 03 May 2012 06:41:08 -0700
From: Eric Nelson <eric.nelson@boundarydevices.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        u-boot@lists.denx.de, rylv50@freescale.com, marex@denx.de,
        vapier@gentoo.org
Subject: Re: [PATCH] checkpatch: add check for whitespace before semicolon
 at end-of-line
References: <http://lists.denx.de/pipermail/u-boot/2012-May/123595.html>	 <1336015938-3174-1-git-send-email-eric.nelson@boundarydevices.com> <1336017507.13866.2.camel@joe2Laptop>
In-Reply-To: <1336017507.13866.2.camel@joe2Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Identified-User: {1412:box284.bluehost.com:boundar4:boundarydevices.com} {sentby:smtp auth 68.230.116.166 authed with eric.nelson@boundarydevices.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Joe,

On 05/02/2012 08:58 PM, Joe Perches wrote:
> On Wed, 2012-05-02 at 20:32 -0700, Eric Nelson wrote:
>> This tests for a bad habits of mine like this:
>>
>> 	return 0 ;
>>
>> Signed-off-by: Eric Nelson<eric.nelson@boundarydevices.com>
>> ---
>>   scripts/checkpatch.pl |    6 ++++++
>>   1 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
>> index a3b9782..0e6977e 100755
>> --- a/scripts/checkpatch.pl
>> +++ b/scripts/checkpatch.pl
>> @@ -3227,6 +3227,12 @@ sub process {
>>   			 "Statements terminations use 1 semicolon\n" . $herecurr);
>>   		}
>>
>> +# check for whitespace before semicolon - not allowed at end-of-line
>> +		if ($line =~ /\s+;$/) {
>
> 		if ($line =~ /\s+;\s*$/)
>
Won't the extra space at end of line be caught by other tests?

>> +		    WARN("SPACEBEFORE_SEMICOLON",
>
> 		WARN("SPACING",
> 	
