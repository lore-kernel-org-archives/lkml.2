Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255Ab2JRQhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 12:37:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46501 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756206Ab2JRQhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 12:37:51 -0400
Message-ID: <50803057.5000307@zytor.com>
Date: Thu, 18 Oct 2012 09:37:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Konrad Wilk <konrad.wilk@oracle.com>, linux-acpi@vger.kernel.org,
        x86@kernel.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, lenb@kernel.org
Subject: Re: [Xen-devel] Is: axe read_tscp pvops call. Was: Re: [RFC] ACPI
 S3 and Xen (suprisingly small\!).
References: <1350481786-4969-1-git-send-email-konrad.wilk@oracle.com> <507ED6C0.4020503@zytor.com> <20121017161036.GA10691@phenom.dumpdata.com> <507EE1C3.7070300@zytor.com> <20121017165452.GA22740@phenom.dumpdata.com> <507EEC53.1010309@zytor.com> <84b3cbf9-7c84-4d7e-a2d7-46b0d1cc5975@default> <50802030.8070107@zytor.com> <dd8748de-4715-499a-8c7e-745af37fa6c4@default>
In-Reply-To: <dd8748de-4715-499a-8c7e-745af37fa6c4@default>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 08:56 AM, Dan Magenheimer wrote:
>
>> Do you notice that the document you just claimed doesn't even exist at
>> this point, never mind being somehow enforced?  In other word, there is
>> ABSOLUTELY NO WAY a mainline kernel developer can have any idea what
>> amount of violence Xen does to the architecture that it is parasiting on.
>
> Of course I know it doesn't exist.  I probably should have
> noted that in my email.  But it should exist because else
> subtle issues like this will get lost in the mist of time.
> And I have no clue how to enforce it (though some BUILD_BUG_ON
> might help).
>

Do you know for how long I have been yelling at various Xen people for 
*not documenting their architecture*?  There are plenty of 
paravirtualized architectures out there which are perfectly well 
documented and supportable, but Xen has resisted doing that for years, 
and all we ever get are vague future promises.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

