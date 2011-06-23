Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538Ab1FWN1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 09:27:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53769 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160Ab1FWN1Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 09:27:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=BAmD903Yg0R/hVJqR5H+vOwIeOHTBs6QRdBfAPvLoWFUvpXEc/0TM9YqgOEnqxRnP+
         oMXoWn34FekWnWm5YUgMMB4kIc6WI82YgSWwlgbU1tYnacCoQxLR3yNWZrgGDKu1eU74
         FVML9ZqzPwRqX6aBl3EReTc6T/IrR6FDwACk4=
MIME-Version: 1.0
In-Reply-To: <BANLkTik3iMqZJiEY1+DYS2T9=+q2x2=5pQ@mail.gmail.com>
References: <BANLkTi=y1roManmZGMLBXSFbBVqK_KqDZg@mail.gmail.com>
 <BANLkTinaPJM3LhEVwFxtEGKuVXOyVOzrzg@mail.gmail.com> <BANLkTik3iMqZJiEY1+DYS2T9=+q2x2=5pQ@mail.gmail.com>
From: yuyichao-mit <yuyichao@mit.edu>
Date: Thu, 23 Jun 2011 09:26:55 -0400
X-Google-Sender-Auth: ee8-9F5GhqUmwGYk6kDRL4xVJoE
Message-ID: <BANLkTik_8mfGgsBq2Lb-R+gBeUy6sLhvHQ@mail.gmail.com>
Subject: Re: extra slash in current path
To: linux-c-programming@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, actually, I mean why is // so special if more than two slash at
the beginning of absolute path become only one slash?

Yichao Yu

On Thu, Jun 23, 2011 at 9:17 AM, Alessandro Suardi
<alessandro.suardi@gmail.com> wrote:
> On Thu, Jun 23, 2011 at 3:14 PM, yuyichao-mit <yuyichao@mit.edu> wrote:
>> The problem is like this:
>>
>> $ cd /
>> $ pwd
>> /
>>
>> $ cd /
>> $ pwd
>> //
>>
>> $ cd ///
>> $ pwd
>> /
>>
>> Why can there be a extra slash (and exactly one) in current path? Is
>> this designed on purpose?
>> This is not really a big deal but I think it can confuse some program.
>
> Multiple consecutive slashes should not confuse any program.
>
> http://pubs.opengroup.org/onlinepubs/009695399/basedefs/xbd_chap03.html#tag_03_266
>
> --alessandro
>
>  "There's always a siren singing you to shipwreck"
>
>    (Radiohead, "There There")
>
