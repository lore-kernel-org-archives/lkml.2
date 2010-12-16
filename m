Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493Ab0LPVh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 16:37:59 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54363 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab0LPVh6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 16:37:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RnW1VL4fyvvWUumH33B9HcEf709xpWyilBpFEjksM9zifYTXZA8O3Oh+qc7Ew7txdN
         OklHEVsW5SE6wLSDsO9wzg2KCGpA2trI1QEfO63BAC4z/um8XSWW2nzagzDt+y1j2vYK
         kZ/Xbdkup/JdkExrWwqB3nRxmQaWM48ksnS6A=
MIME-Version: 1.0
In-Reply-To: <4D0A866E.40708@suse.cz>
References: <AANLkTik90p-L+4_GnwXzoekCK0E2uemZD6tOK_kEFd2n@mail.gmail.com>
	<4D0A866E.40708@suse.cz>
Date: Thu, 16 Dec 2010 13:37:57 -0800
Message-ID: <AANLkTi=Nd76X3dKAi_A3M=8tHbmgqO3DH11eo0stAQWO@mail.gmail.com>
Subject: Re: PATCH: Put .zdebug* section on white list
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 1:36 PM, Michal Marek <mmarek@suse.cz> wrote:
> On -10.1.-28163 20:59, H.J. Lu wrote:
>>
>> Hi,
>>
>> "as --compress-debug-sections" will generate compressed debug sections
>> with section names ".zdebug*".  This patch puts .zdebug* section on
>> white list.
>
> Hi,
>
> can I assume that the patch is
> Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
> ?
>

Yes.


-- 
H.J.
