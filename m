Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab1FDMfa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 08:35:30 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60588 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab1FDMf2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 08:35:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uVXKr0C1GcWxxG2UxebEf6O5i/bfPPt+4XUNo02FDwhoQ8nmuKLNitn5Hfm1mMR2ED
         Ol4adp9vXc8R5YXQ7P6KDg/Iz1gl2ZHHhzcX6rz+uh40x9iP0f3TYwT8/sQnNnWSNC3A
         gvA28TmtTEolC0Vwrr3RWDv8IMrt+2S9YPIxc=
MIME-Version: 1.0
In-Reply-To: <4DE8F989.50208@hist.no>
References: <4DE6103E.6010100@hist.no>
	<4DE8B449.2000008@suse.de>
	<4DE8F989.50208@hist.no>
Date: Sat, 4 Jun 2011 07:35:25 -0500
Message-ID: <BANLkTik15fEwzS5m6xWvMxKesYkQGArfPw@mail.gmail.com>
Subject: Re: [2.6.39] CIFS write failures where 2.6.38 works
From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
To: Helge Hafting <helge.hafting@hist.no>
Cc: Suresh Jayaraman <sjayaraman@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 3, 2011 at 10:11 AM, Helge Hafting <helge.hafting@hist.no> wrote:
> On 03. juni 2011 12:15, Suresh Jayaraman wrote:
>>
>> [Cc linux-cifs@vger.kernel.org]
>>
>> On 06/01/2011 03:41 PM, Helge Hafting wrote:
>>>
>>> At work I use cifs for accessing a windows server. This has worked fine
>>> for a long time, up to and including Debian's 2.6.38-2.
>>>
>>> I just installed Debians's 2.6.39-1, and had to give up on it.
>>> Mounting CIFS works, and I can see the files. But if I
>>> try to make a new file (with cp), I get a long delay.
>>
>> What is the security mechanism you are using? If you seeing the problem
>> with ntlm, could you try using ntlmv2 and see whether the problem is
>> reproducible?
>
> In the beginning, I did not specify the mechanism. So, whatever the default
> is.
>
> The fstab entry was like this:
> \\servername\resource /mountpoint cifs
> domain=MYDOMAIN,credentials=/etc/fstabcred,rw,noauto,iocharset=utf8,uid=username,gid=group,sockopt=TCP_NODELAY,users,file_mode=0640,dir_mode=0750,relatime
> 0 0
>
> I looked at cifs options, and tried to add "sign" and "sec=ntlmv2i". It made
> no difference. Still failure with 2.6.39, and mounting with these new
> options works fine with 2.6.38
>
> Helge Hafting
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Yes, I think wireshark trace would be really useful.

Regards,

Shirish
