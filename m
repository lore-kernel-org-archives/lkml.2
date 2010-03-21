Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab0CUU3s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 16:29:48 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:55296 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab0CUU3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 16:29:47 -0400
X-Greylist: delayed 436 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Mar 2010 16:29:46 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=LSZb3UD/oee9/KCp8Ln7+Vr3VTjst298NVxLJxsRDqV3BsVx75MMjOgnqeU4sHj+2E
         SPKRJscgf+hZt30/YRR3IwLIdWAX4wgGFXjilTmjM5Kmk7/1oDEsRWoFXecDvZUMKpS0
         E0cAorFyEeN2hMGvhSbC6wQ0FGUjPPVXlwvLU=
MIME-Version: 1.0
In-Reply-To: <20100321200450.GD1933@elf.ucw.cz>
References: <1269041205-23129-1-git-send-email-lindley@coyote.org>
	 <20100321200450.GD1933@elf.ucw.cz>
Date: Sun, 21 Mar 2010 22:22:29 +0200
X-Google-Sender-Auth: 972040cfef382999
Message-ID: <84144f021003211322m6d45a391p860cff532c7b4a77@mail.gmail.com>
Subject: Re: [PATCH] staging: winbond: mto.c Coding style fixes
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Lars Lindley <lindley@coyote.org>, gregkh@suse.de, greg@kroah.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 21, 2010 at 10:04 PM, Pavel Machek <pavel@ucw.cz> wrote:
> On Sat 2010-03-20 00:26:45, Lars Lindley wrote:
>> I changed all things reported by checkpatch.pl except some long lines
>> and the use of externs in a .c file. I also removed revision comments
>> and "commented out" code.
>> Please review this closely as the generated .o differs from the
>> mainline one but I suspect that is because I removed the explicit
>> initialization to 0 in a couple of statics..
>> There are also some very deep if-if-else-if-ifs that I might have messed
>> up :)
>>
>> Signed-off-by: Lars Lindley <lindley@coyote.org>
>
> ACK.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
