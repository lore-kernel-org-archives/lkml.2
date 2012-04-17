Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab2DPXFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 19:05:48 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:55813 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755659Ab2DPXFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 19:05:47 -0400
Message-ID: <4F8CCFFF.2060808@xenotime.net>
Date: Mon, 16 Apr 2012 19:05:51 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: linux-kernel@vger.kernel.org, trivial@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] [Trivial] ktest: change singular "paranthesis" to plural
 "parantheses"
References: <alpine.LNX.2.00.1204170027250.21898@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1204170027250.21898@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 03:28 PM, Jesper Juhl wrote:

> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  tools/testing/ktest/sample.conf |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

It's misspelled before and after the patch.  :(


> diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
> index b682456..1a6e0d9 100644
> --- a/tools/testing/ktest/sample.conf
> +++ b/tools/testing/ktest/sample.conf
> @@ -158,7 +158,7 @@
>  #
>  # TEST_START IF (DEFINED ALL_TESTS || ${MYTEST} == boottest) && ${MACHINE} == gandalf
>  #
> -# Notice the use of paranthesis. Without any paranthesis the above would be
> +# Notice the use of parantheses. Without any parantheses the above would be
>  # processed the same as:
>  #
>  # TEST_START IF DEFINED ALL_TESTS || (${MYTEST} == boottest && ${MACHINE} == gandalf)



-- 
~Randy
