Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593Ab1ANDAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 22:00:16 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60950 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757573Ab1ANDAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 22:00:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iLPtxqQ/JFQOHkmFOfY8d+Ux99D/h79HKbb1iKvD0cFWrX/Iju4JHTznYNC1ZU94fr
         vJEXPdianc8fTkJ69wXXRG7+VubE8Eow6HGX9M6/QOG/nyLiMsKxBwa34btMdmWx2sim
         eUWQmaGLxesN7Q7RbicUthpHdmLBzmCcXYQXA=
Message-ID: <4D2FBC34.6050901@gmail.com>
Date: Thu, 13 Jan 2011 22:00:04 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
CC: Stephen Hemminger <shemminger@vyatta.com>,
        Linux Kernel Developers <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v1 2/2] TCPCT API sockopt update to draft -03
References: <4D2DE824.10205@gmail.com>	<4D2DEC0A.70608@gmail.com>	<20110112105608.793787b2@s6510>	<4D2F3723.9040405@gmail.com> <AANLkTinhnaF3-scKnTOC5rF68+5otVW2NG3v1y80L0k6@mail.gmail.com>
In-Reply-To: <AANLkTinhnaF3-scKnTOC5rF68+5otVW2NG3v1y80L0k6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/13/11 12:53 PM, Arnaud Lacombe wrote:
> On Thu, Jan 13, 2011 at 12:32 PM, William Allen Simpson
> <william.allen.simpson@gmail.com>  wrote:
>> Even though I'm not paid to work on Linux, I'm doing my best to give you
>> folks a quick heads up and provide code to rectify the very recent changes
>> that can be propagated back through the stable tree (to 2.6.33).
>>
>> As always, what you actually do with my code is up to you....
>>
> FWIW, what is the basis of this hunk ? The RFC text[0] seems to use
> the TCP_COOKIE_* naming, not TCPCT_.
>
> Thanks,
>   - Arnaud
>
> [0]: http://www.rfc-editor.org/authors/rfc6013.txt
>
Is this supposed to be humorous?  Maybe folks here find it amusing that
somebody thinks they know more than the *author* about the contents of the
document?  Did you note the words above?  That is, "very recent changes"?

Perhaps you are viewing an older cached version.  Please check for the
current month on every page: "January 2011".

We discussed -- and ultimately decided -- these changes in private email
during the independent review process before making them available to the
general public.  That's how the RFC publication procedure works.

I tried to be helpful to the Linux community in advance of publication, so
you would be prepared.  I'm sorry that the community here is so lacking in
appreciation for my efforts on your behalf.

As always, what you actually do with my code is up to you....
