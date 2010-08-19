Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab0HSTfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 15:35:36 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49231 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab0HSTfe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 15:35:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=LxJWmlwOWkc47isBiDy/oKRzEx31zMtfcwSXHD5DQf9S6CE0POQC/V9ywQ71aTcr6L
         PY3Zwhob2lYTZ04yUUluTc51rcxoBvL35+07u+igAYcil2IdKjFPMjNBa6I2JQYr7x9X
         RachnZ+NQF7khdsAqZeHtiHPLoZ75NqbmlfRY=
MIME-Version: 1.0
Reply-To: trapdoor6@gmail.com
In-Reply-To: <201008191707.52057.maciej.rutecki@gmail.com>
References: <201008182102.03201.maciej.rutecki@gmail.com>
	<AANLkTik3S91w+92rz-KdHd_U=yfuSPbDWWhD_Vu_rDR9@mail.gmail.com>
	<AANLkTik4=_3wSNpkfqssWsmG_yCYOPFsA-cMDBaVU4BB@mail.gmail.com>
	<201008191707.52057.maciej.rutecki@gmail.com>
Date: Thu, 19 Aug 2010 20:35:31 +0100
Message-ID: <AANLkTin-rTo2Kn9Udoxb7NJQt0Fmbf8yJ1iuJMM0T3aK@mail.gmail.com>
Subject: Re: [REGRESSION] [SUSPEND] Opps during suspend to disk (probably also
 during to ram)
From: trapDoor <trapdoor6@gmail.com>
To: maciej.rutecki@gmail.com
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 4:07 PM, Maciej Rutecki
<maciej.rutecki@gmail.com> wrote:
> On środa, 18 sierpnia 2010 o 23:27:14 trapDoor wrote:
>
>>
>> Maciej,
>> Just FYI I have updated the bugzilla entry
>> (https://bugzilla.kernel.org/show_bug.cgi?id=16615) with relevant
>> details.
>
> Patch works also on my machine, but I found another problem [1].
>
> Thanks!
> --
> Maciej Rutecki
> http://www.maciek.unixy.pl
>
> [1] https://bugzilla.kernel.org/show_bug.cgi?id=16629
>

Just FYI, regarding the suspend issue, that HID patch was included in
yesterday's pull request [http://lkml.org/lkml/2010/8/18/225] and it's
upstream now ..

-- 
Regards
Tomasz B.
