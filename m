Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab2DPXP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 19:15:28 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:58717 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752000Ab2DPXP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 19:15:27 -0400
Message-ID: <4F8CD243.30900@xenotime.net>
Date: Mon, 16 Apr 2012 19:15:31 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: linux-kernel@vger.kernel.org, trivial@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] [Trivial] ktest: change singular "paranthesis" to plural
 "parantheses"
References: <alpine.LNX.2.00.1204170027250.21898@swampdragon.chaosbits.net> <4F8CCFFF.2060808@xenotime.net> <alpine.LNX.2.00.1204170110460.21898@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1204170110460.21898@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 04:12 PM, Jesper Juhl wrote:

> On Mon, 16 Apr 2012, Randy Dunlap wrote:
> 
>> On 04/16/2012 03:28 PM, Jesper Juhl wrote:
>>
>>> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
>>> ---
>>>  tools/testing/ktest/sample.conf |    2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> It's misspelled before and after the patch.  :(
>>
> Ahh, crap, you are right. Sorry about that :-(
> 
> I could try to blame that on english not being my first language, but I 
> won't since it's just me screwing up.
> I did read the patch several times before sending it and thought I'd made 
> sure there were no trivial errors like that, but I was wrong - damn it.
> 
> 
> This should be better :
> 
> From: Jesper Juhl <jj@chaosbits.net>
> Date: Mon, 16 Apr 2012 19:40:24 +0200
> Subject: [PATCH] [Trivial] ktest: change singular "paranthesis" to plural "parentheses"
> 


Looks good.  Thanks.

Acked-by: Randy Dunlap <rdunlap@xenotime.net>


> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  tools/testing/ktest/sample.conf |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
> index b682456..2d5109f 100644
> --- a/tools/testing/ktest/sample.conf
> +++ b/tools/testing/ktest/sample.conf
> @@ -158,7 +158,7 @@
>  #
>  # TEST_START IF (DEFINED ALL_TESTS || ${MYTEST} == boottest) && ${MACHINE} == gandalf
>  #
> -# Notice the use of paranthesis. Without any paranthesis the above would be
> +# Notice the use of parentheses. Without any parentheses the above would be
>  # processed the same as:
>  #
>  # TEST_START IF DEFINED ALL_TESTS || (${MYTEST} == boottest && ${MACHINE} == gandalf)



-- 
~Randy
