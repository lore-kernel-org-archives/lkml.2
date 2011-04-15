Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab1DOGXu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 02:23:50 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33445 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab1DOGXt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 02:23:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=V1dZdOvwiGheoDx/Z1j96BmDCilESdKZRO85rJULt4KbQv5AYvn2TOOXKeRlw2/n78
         w6jHVGOEMYh0BO+4lkToR1py4vHg5mUiGeeTUD2DUN1Lkqq6DTCeAMkA0YU8rQIHQyYS
         iWU29o5tUXIxkhdihzObSSSMMAvBDlT98UxME=
MIME-Version: 1.0
In-Reply-To: <1302847688-8076-1-git-send-email-namhyung@gmail.com>
References: <BANLkTinDFrbUNPnUmed2aBTu1_QHFQie-w@mail.gmail.com>
	<1302847688-8076-1-git-send-email-namhyung@gmail.com>
Date: Fri, 15 Apr 2011 15:23:48 +0900
Message-ID: <BANLkTik_ztG7JsuskO=umc1A0466P7HvKg@mail.gmail.com>
Subject: Re: [PATCH v2] mempolicy: reduce references to the current
From: Minchan Kim <minchan.kim@gmail.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 3:08 PM, Namhyung Kim <namhyung@gmail.com> wrote:
> Remove duplicated reference to the 'current' task using a local
> variable. Since refering the current can be a burden, it'd better
> cache the reference, IMHO. At least this saves some bytes on x86_64.
>
>  $ size mempolicy-{old,new}.o
>     text    data    bss     dec     hex filename
>    25203    2448   9176   36827    8fdb mempolicy-old.o
>    25136    2448   9184   36768    8fa0 mempolicy-new.o
>
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
