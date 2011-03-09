Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab1CISCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 13:02:44 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43240 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128Ab1CISCm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 13:02:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GTfp4wGFfyBlsSB3Q9OLRnNj1P525lpicq2gWsj+X3TiazMv7+rTkmpEHJDhIKjis5
         2kwg/TA/qW9lEDm3owEmnduwcRscILDbNrX/e5d0mr5x9s1u9CYM8GOyaqsmeYMl3mp6
         iJbmHV+kpQBhHWq8AzUjOAt4a/jOVusqAytJM=
MIME-Version: 1.0
In-Reply-To: <op.vr27erd63ri7v4@arend-laptop>
References: <AANLkTinhThfS587rkX4y1UbJLQzQKEWGfrFArUVGD3Ew@mail.gmail.com>
	<op.vr2jgfwg3ri7v4@arend-laptop>
	<20110309160046.GA30821@suse.de>
	<op.vr27erd63ri7v4@arend-laptop>
Date: Wed, 9 Mar 2011 19:02:41 +0100
Message-ID: <AANLkTinT0Ke_c4O3+EkCAo01O-X8E5-3jET6MT7aX0Ne@mail.gmail.com>
Subject: Re: brcm80211: the system freezes if booted with laptop wifi switch
 to OFF
From: Francis Moreau <francis.moro@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Greg KH <gregkh@suse.de>, Brett Rudley <brudley@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 9, 2011 at 6:41 PM, Arend van Spriel <arend@broadcom.com> wrote:
> On Wed, 09 Mar 2011 17:00:46 +0100, Greg KH <gregkh@suse.de> wrote:
>
>> Sure, but I will wait and add it to the stable releases when it goes
>> into Linus's tree.  Sound ok?
>
> fine by me. Will sent the patch later today.
>

please Cc me so I could give it a test.

-- 
Francis
