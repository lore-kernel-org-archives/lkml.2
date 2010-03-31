Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413Ab0CaF5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 01:57:08 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:43409 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128Ab0CaF5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 01:57:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=iPOvnj3MFQ2Isv5a8W7ICpJQQSQ/zNjBhCQykw0Iwf3pn3qJM3H4vhxIeXxdCi3hqs
         ixXlHCGaWt+eQg51colp/vNYljvHzx/1+w5F3g1aws3w/XRrKp/Yeny70JXs8LEAOVE9
         njN48vQfkDTuDeY1AiHT1/zovaZmYXR8Afecg=
MIME-Version: 1.0
In-Reply-To: <1270014499.14822.1.camel@Joe-Laptop.home>
References: <912ec82a1003300907o7edeb73bp92d56741cfee1064@mail.gmail.com>
	 <1269967960.4558.162.camel@Joe-Laptop.home>
	 <u2y912ec82a1003302242sb4f1ac2arb9c464d35993b7a1@mail.gmail.com>
	 <1270014499.14822.1.camel@Joe-Laptop.home>
Date: Wed, 31 Mar 2010 08:57:02 +0300
Message-ID: <m2s912ec82a1003302257hbdc662d9pdbecaf73fd93d071@mail.gmail.com>
Subject: Re: pr_* versus dev_*
From: Neshama Parhoti <pneshama@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 8:48 AM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2010-03-31 at 08:42 +0300, Neshama Parhoti wrote:
>> so i should use whatever print call that adds most information right ?
>
> I think so.
>
>> even if that means that some part of the driver uses pr_* and some
>> part of the driver use dev_* ?
>
> Yes.
>
>

thank you !
