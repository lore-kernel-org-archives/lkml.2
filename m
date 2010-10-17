Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044Ab0JQKw1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 06:52:27 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37961 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab0JQKw0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 06:52:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=Jx4uIcD5rusrz3Mu/Bbv/l1ivXwtyBL2J11cHwc5dPOrCSDR2UtM3NgZJn0RwTPjKL
         2lKGLO7/YEHq2SyjFVBHz40GESNG22jB+tBL7T3jdGMeyV0vSuxtPCccdWxEDy0AUMFk
         K8PTA7xdxfvLdxv6wGRH4N6oN08g2aqWgLAqo=
MIME-Version: 1.0
In-Reply-To: <1287311875.1998.156.camel@laptop>
References: <1287302737-3507-1-git-send-email-vapier@gentoo.org>
 <1287303678.20968.37.camel@Joe-Laptop> <AANLkTimmSRS3eVsW4EZUxnE_rfjeqmmgGnjtWbn3J_nY@mail.gmail.com>
 <1287310889.1998.153.camel@laptop> <AANLkTin6H2AbL_Kr4XCtPOr+SQRxi0tKKF3puY4gybNu@mail.gmail.com>
 <1287311875.1998.156.camel@laptop>
From: Mike Frysinger <vapier@gentoo.org>
Date: Sun, 17 Oct 2010 06:52:04 -0400
X-Google-Sender-Auth: U4WqfW2XWuB9B8x7BGH7sb0WJvk
Message-ID: <AANLkTik8yz_e2b+h8n0=40ar6G82Oior9O0XJ5u-uT0W@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: allow single space before labels
To: Peter Zijlstra <peterz@infradead.org>
Cc: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 06:37, Peter Zijlstra wrote:
> On Sun, 2010-10-17 at 06:30 -0400, Mike Frysinger wrote:
>> On Sun, Oct 17, 2010 at 06:21, Peter Zijlstra wrote:
>> > On Sun, 2010-10-17 at 04:24 -0400, Mike Frysinger wrote:
>> >> feel free to extend however as long as the end result is no warnings
>> >> for " foo:" ;).
>> >
>> > I utterly detest those indented labels and am eradicating them wherever
>> > I notice them. There's really no sane reason to use them what so ever.
>> > Diff can be taught not to get confused about them, see my earlier email.
>>
>> sure, with enough shell code thrown at a problem, you can do anything.
>>  the change that started these warnings was for an unrelated check.
>> no one proposed warning on indented labels, nor is there any statement
>> at all in the coding style on these.
>>
>> considering you highlighted the biggest reason (diff by default does
>> not handle them properly), i think that invalidates against your "no
>> sane reason" statement.
>
> I think telling people to change their diff rules (--show-c-function
> isn't default enabled either) is a lot better option than to uglify the
> source. These indented labels are totally annoying when reading code.

and that is your opinion on the matter.  mine happens to go the
opposite way.  i prefer the single space when reading code.
-mike
