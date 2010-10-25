Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab0JYQDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 12:03:17 -0400
Received: from web37601.mail.mud.yahoo.com ([209.191.87.84]:27074 "HELO
	web37601.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751414Ab0JYQDQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 12:03:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=YUqWbjvLz3+qiMyk9vpTy7TNHathhL2cpfyWvNbgsUQquMqIZTgzl67/89+8reuSJjuAzWSijqPJ6phP4uA9f68zeHQgug3aCuEBFbyijJYgDFDkaanDUxXwaLJExsZ4BTlCLefopjms3RIWgjBnOA7eDF+5X5srRpE9sAP7/4Q=;
Message-ID: <747229.25358.qm@web37601.mail.mud.yahoo.com>
X-YMail-OSG: lTKQl5MVM1md_wHCbKmjhi15YILlI8d3bZcFaT7sVQiTy6A
 7jV80lvSzeuZoTzw2EF4CcvU6Wn.8erQHw8fLDQ7nE0SzzhISpUqBRDZXsij
 c3zcxEV9xyIX5bskKV4Mmw.U8U2f.cg7GjBJ6rdfiwcfUFozFGdIyEQjWAjn
 Cd3nSVDFn4bMpvFRFJ1Kr9L.3COomADJ78g2JgNlMsz57ClVJhXhTlE4K5qv
 w3uzjv45gE1fdcA76PzbzQBGG0pzMm.6TaaXkf2f.MMJ8kr7FA36eH97GomV
 kP0oXrBD9e7cdAzS5Ns1uYu7oi2CAbmxhjT1RnaKZ0vgf6fm6lcwsT5KwBQo
 mApkyHHlBXPH9fCtVPU2rlVZXtkJJED5YE1i8kkUKtaT5YYuC
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Mon, 25 Oct 2010 09:03:15 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 19/29] memstick: jmb38x_ms: add register read/write functions
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
In-Reply-To: <1287791637-10329-20-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Subject: [PATCH 19/29] memstick: jmb38x_ms: add register read/write functions
> To: "Alex Dubov" <oakad@yahoo.com>
> Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> Received: Friday, 22 October, 2010, 4:53 PM
> All over the code it is a bit easier
> to see the
> register access with this patch. Also set/clear mask
> helpers refactor code a bit, but the biggest reason
> for this patch is to make it possible to trace register
> read/writes with a flip of a module param.
> 
> Currently these functions are unused, but will be by later
> code
> 
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>

This looks like a case of:
1. You've run into a technical difficulty.
2. You used some temporary code to resolve and document it.
3. Now this temporary code is forever here to stay.




      
