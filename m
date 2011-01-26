Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab1AZN4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 08:56:44 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59756 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab1AZN4n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 08:56:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=ufqyKs2ctrXIZCjPT1C1TSuu86Ogyq5Dex+eti5djr4sOJ0U78dQTn3PPuLbxJD8Ut
         0GbMZCgwTUKSc0AQjjKhn0ZsCXaENT4lwfbPK+laIaWYN6eDjaTd8tQsVZOr/0ZNOoqG
         mbfjL9ScfRTtsseSPqTNa35JbkmZKq5m16lOQ=
MIME-Version: 1.0
In-Reply-To: <20110126134318.GO2721@bicker>
References: <1296042555-29145-1-git-send-email-marek.belisko@open-nandra.com>
	<1296042555-29145-4-git-send-email-marek.belisko@open-nandra.com>
	<20110126130718.GN2721@bicker>
	<20110126134318.GO2721@bicker>
Date: Wed, 26 Jan 2011 14:56:42 +0100
Message-ID: <AANLkTim7D6qurGo+EVhg+ysQTcduh02sjygkO_mxk+iR@mail.gmail.com>
Subject: Re: [PATCH 4/5] staging: ft1000: Fix coding style in write_blk_fifo() function.
From: Belisko Marek <marek.belisko@gmail.com>
To: Dan Carpenter <error27@gmail.com>,
        Marek Belisko <marek.belisko@open-nandra.com>, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 2:43 PM, Dan Carpenter <error27@gmail.com> wrote:
> On Wed, Jan 26, 2011 at 04:07:18PM +0300, Dan Carpenter wrote:
>> You didn't introduce it but do you know what the code is trying to do
>> here?
>>
>>         byte_length = word_length * 4;
>>
>>         if (byte_length % 4)
>
> Actually this check is pointless.  word_length * 4 is always
> aligned at 4 bytes.
OK will post in separate patch. Original was just about coding style.
Thanks for reviewing.
>
> regards,
> dan carpenter
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

thanks,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
icq: 290551086
web: http://open-nandra.com
