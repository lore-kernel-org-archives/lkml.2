Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab1HLCtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 22:49:52 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:44245 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab1HLCtt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 22:49:49 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1108121244250.14779@tundra.namei.org>
References: <1313090079-25859-1-git-send-email-zohar@linux.vnet.ibm.com>
	<CACLa4ptNaOvwFX-2VPBve=PBvnB7X85tzTnTPSLtprbT8vSGgw@mail.gmail.com>
	<1313092847.3122.13.camel@localhost.localdomain>
	<CAH2r5muSOM=haAXHg+ys05vgJ30m94g_NQz-Y2AgMDkmV1dbiw@mail.gmail.com>
	<alpine.LRH.2.00.1108121047540.14215@tundra.namei.org>
	<20110812114919.2797815cf41cd69048e1d3cf@canb.auug.org.au>
	<alpine.LRH.2.00.1108121244250.14779@tundra.namei.org>
Date: Thu, 11 Aug 2011 21:49:48 -0500
Message-ID: <CAH2r5mssB+3vDmNy3mWvGBDYXDu_NYiSZAFOxQXcckr+tHUV4A@mail.gmail.com>
Subject: Re: [PATCH] CIFS: remove local xattr definitions
From: Steve French <smfrench@gmail.com>
To: James Morris <jmorris@namei.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Eric Paris <eparis@parisplace.org>,
        linux-security-module@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If it is easier - I don't mind merging it to cifs now.   Seems
harmless and low risk.

On Thu, Aug 11, 2011 at 9:44 PM, James Morris <jmorris@namei.org> wrote:
> On Fri, 12 Aug 2011, Stephen Rothwell wrote:
>
>> Except then that could leave Linus' tree broken during the next merge
>> window depending on the order he merges the cifs and security-testing
>> trees.  Unless that patch is sent to Linus as a fix patch before the next
>> merge window, of course.
>>
>> I will add this patch as a merge fixup to the merge of the
>> security-testing tree for today.  And will remove my copy when one of the
>> trees gets fixed.
>
> I'll put it in my tree, then.
>
>> James: maybe I should change the name of your tree in -next to just
>> "security"?
>
> Sure.
>
>
> --
> James Morris
> <jmorris@namei.org>
>



-- 
Thanks,

Steve
