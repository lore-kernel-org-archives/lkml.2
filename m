Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab0LBKAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 05:00:23 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39693 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab0LBKAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 05:00:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=oDzSY3AfdLxtFXxt2Vo/ekPMUe+QiPVGjiBUYH7jcuL0/cAfMRnXy+CGeNGqwwMT69
         vMII9M/JPoIMr0k2FKdfrA9H85ggP3+BnGfUcizxaYgsYv5GPuinz0GmqNXNznui7zGu
         y9/mDZSAfMpUcDAvs+21KZb/WMPZsWdOJieZk=
MIME-Version: 1.0
In-Reply-To: <20101201155441.GA22342@brouette>
References: <AANLkTimDVNfTavhLD9=yD=EYWASoRZQy9FCHkiLNgYFJ@mail.gmail.com>
	<20101201155441.GA22342@brouette>
Date: Thu, 2 Dec 2010 11:00:20 +0100
Message-ID: <AANLkTi=2si0Gq-DmA0D=TWk=rfxRDiDM5P6YwFSzHXsw@mail.gmail.com>
Subject: Re: timer.c - high load avarage with idle cpu
From: Harry Nak <harrynak@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Damien Wyart <damien.wyart@free.fr> wrote:
>> [...]
>> My solution is to postpone the call to run_local_timers() until
>> scheduler_tick() has been called.
>
>> Could anybody confirm my theory and is it possible that my solution
>> breaks anything?
>
> Your problem might be related to this thread:
> https://lkml.org/lkml/2010/9/29/51

Thanks for the hint. However from what I have read in this thread,
this deals specifically with a tickless kernel, while my issue
manifests on a regular HZ kernel.

- Harry
