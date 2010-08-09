Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab0HIGmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 02:42:23 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:50163 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab0HIGmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 02:42:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=PdLxu4QR45/s8eGOr1mBxwXtFixOaSWRC/qHe4NFE0sy6S84Jy0pORvY8Fj8PnxdW9
         dG0+5bLvtj6p1WryqsOPFN9zoYURllUD2i5hK7pSCfvj29+TWg4JZP3eLBZwBsvNNSxu
         mVNDufZCgyozC9GhJNjqWW6u5cbjk1BBqOI1s=
Message-ID: <4C5FA35E.50309@gmail.com>
Date: Sun, 08 Aug 2010 23:42:38 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: viresh kumar <viresh.kumar@st.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Query: Patches break with Microsoft exchange server.
References: <4C5F9B25.8080401@st.com>
In-Reply-To: <4C5F9B25.8080401@st.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2010 11:07 PM, viresh kumar wrote:
> Hello,
>
> Mail server in ST has recently changed and now we have Microsoft
> exchange server. We are using thunderbird as mail client.
> What we observed with this server is that patch are broken now while
> sending as well as receiving. Tabs are replaced by spaces and may
> be some other too which we haven't observed.
>
> Has anybody found a solution to this kind of issues? Are there any
> workarounds possible?
>
> viresh
> ST Microelectronics.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


still trying to figure this out with thunderbird.. but did notice in 
Documentation/email-clients.txt and SubmittingPatches
there's info about that(just haven't gotten around to reading use git 
send-email for patches)

hope this helps.

Justin P. Mattock
