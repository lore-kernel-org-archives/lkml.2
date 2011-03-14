Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab1CNT2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 15:28:32 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58191 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab1CNT2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 15:28:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=T4vr7RKWCWzEDsbBSKc0bvw7N/KeEJuhTPv7x1Jzs7wbI06ePecIq74hfpL8xfthxX
         TY7WdMTHa0BWCdoPGcExLc4ktif++i5lXR9gprnKQi4OZ6CLsl3DHIpOSGTwFkH4i624
         m1998J/X92LeQLqlYAsKw8Qp4F+Ap2qrAp4rI=
MIME-Version: 1.0
In-Reply-To: <20110314190813.GC20259@home.goodmis.org>
References: <AANLkTim9jsGz=ELPNUVJHWN8Z4EzBrFA03XXt_QYPsEh@mail.gmail.com> <20110314190813.GC20259@home.goodmis.org>
From: Justin <wellspring3@gmail.com>
Date: Mon, 14 Mar 2011 12:28:11 -0700
Message-ID: <AANLkTimE94jf0N54c5ijKUs3Ln_hhNUuCecuda98y2O9@mail.gmail.com>
Subject: Re: milw0rm rootkit
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, she runs 2.6.34.8-68.fc13.i686.PAE

I know this is for the kernel... The C file seems to exploit a
vulnerability in the kernel, so I thought I should let the kernel
people know so they could patch it upstream. Right? I know the hacker
couldnt have gotten in if the security was stronger, but shouldnt the
kernel be secured against the rootkit?

On Mon, Mar 14, 2011 at 12:08 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Sun, Mar 13, 2011 at 07:31:43PM -0700, Justin wrote:
>> My mothers computer was hacked with a program that seems to be
>
> Your mom runs Linux? Which distro?
>
>> milw0rm. The hacker left the source file in C on her computer. I have
>> it and the IP address of the FTP server that he seemed to download it
>> from. Who can I give the file to to be sure that it gets patched? And
>> is there anything else I should do to help you guys make sure that
>> this doesnt happen again?
>
> This is the Linux kernel mailing list, which I'm pretty sure was not the
> cause of the hack, and thus the wrong list. Please contact the people
> from the distribution that you are using.
>
> -- Steve
>
>
>>
>> I am not on the list, so please CC me any responses, thanks
>
