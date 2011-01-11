Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab1AKC6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 21:58:50 -0500
Received: from web37605.mail.mud.yahoo.com ([209.191.87.88]:39704 "HELO
	web37605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753708Ab1AKC6q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 21:58:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=eOVWCqkGIuCqTcj3TJkG11mhEenEiHnbSWpj5FVyizvkxOl+2H5Yj3Va5w4LXXVq2Ij7oQgfbnJRejIFK7rwxo0wlYWGedo+HyP/licqut/KR3Md7i1ne38mxOHIQuT0DXvTEcp1CFZ6Uaii4bjcTOJv0yQeJrZavYJ/UVxbmNg=;
Message-ID: <890633.77912.qm@web37605.mail.mud.yahoo.com>
X-YMail-OSG: ob5VunIVM1kWXELgipAr1zDfglx5obT0SoZ7XMMd8rdR.2j
 qxP16azD3qiqMr4cPqXRqOdHANubF0kta5HTmxV7_zsINqY4b2AjTT6DV2bD
 DVoDmp3M.aOI2mLj.DpHPfn_ilL4OULXoWsDVAWRtgJiux6pbwEqewrEDwjU
 IdUXkIxGJ3zj5LyPePBL0etNwsV2Qpytj.YFA8EMWjj7C8DJFRUKGYLcjExJ
 pL._Hxg_szh.SuS7SUXCroxIyDLtTr8Lq2R5E2ygETwr9G1YWYjujO4Y18oK
 Wa4.n1b0UaC_N5sEXDxxVDHfFkaCiGdEo1ompmZNCuhcAIq6tY05muHQysun
 KdAoHnGFfU8aAo9g9YXZh44.orE3SieT7TTuISs_Ua46hC7azaW8pUMM0Xab
 aLjZ.B7j7zZM_
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Mon, 10 Jan 2011 18:58:45 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 1/4] scatterlist: new helper functions
To: Andrew Morton <akpm@linux-foundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> The functions that were added:
> 
> * sg_nents/sg_total_len - interate over sg list to figure

You've got a typo here.

> out its total len, number of entries.
> Useful for not keeping that information in side channels.
> 

> Allows to transparetly compare contents of the sg list to
> given linear

And here.

> buffer.
> If needed later, a function that compares two sgs can be
> added.
> 
> All of this code is used by my ms_block.c driver.
> 

I definitely find this useful.
But, of course, we need to ask somebody from the memory management
department to look at it, as this patch is intended to be not memorystick
specific.





      
