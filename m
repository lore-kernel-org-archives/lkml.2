Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787Ab0LZJIF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 04:08:05 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61120 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab0LZJIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 04:08:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xdWfFJvNmFrVAQ+N1nvLsXLvQzvf3fZSdjau4SIGuuJX6G4Ry6VbWH5jlVRbYyP5+a
         pIL3Ne/jXjYFnLh5Yjum8kf9E1opPHZ0WsZ1cjkAgK37HFc0IkPBGuX0R0G7PcscUDH/
         +bYkqvMpRqFHKQPW6z5EojQgVFuki2zATHBOg=
MIME-Version: 1.0
In-Reply-To: <AANLkTinye4NY6D=pHWRKTW=smhS3qg1kfBW7wncQgXSU@mail.gmail.com>
References: <AANLkTim0Xmsnzz5yMLAx_+w-c7sSSReu0SKMAmjpbS+1@mail.gmail.com>
	<AANLkTi==ahwQXGK-hPq+2KVRRwQiL9j7vVakAwi=NTiq@mail.gmail.com>
	<AANLkTinye4NY6D=pHWRKTW=smhS3qg1kfBW7wncQgXSU@mail.gmail.com>
Date: Sun, 26 Dec 2010 15:08:01 +0600
Message-ID: <AANLkTinNhupY59gYJNi_za8UvgGkjFA9mbdkKfwfKWeQ@mail.gmail.com>
Subject: Re: [PATCH v0] add nano semaphore in kernel
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 26, 2010 at 1:04 PM, Hillf Danton <dhillf@gmail.com> wrote:
> On Sun, Dec 26, 2010 at 2:46 PM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
>> On Sun, Dec 26, 2010 at 11:13 AM, Hillf Danton <dhillf@gmail.com> wrote:
>> Above description tells how its done, what it is but its not clear why
>> we should use it. Can I know why should we use it or its benefits?
>>
>
> The outstanding benefit looks that nano semaphore could be used in
> cases where callers want to wait not only more than one jiffy, but far
> less than one jiffy also.
>
But, how do we know that resources are going to be available within
one jiffy or far less than one jiffy? We we be deterministic?

thanks,
rakib
