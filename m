Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab0JYOoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 10:44:08 -0400
Received: from web37601.mail.mud.yahoo.com ([209.191.87.84]:35894 "HELO
	web37601.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755578Ab0JYOoG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 10:44:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=55TT9Y8Wev9Q6xfsFfnJwnkd6rFtkf5CgZArgZ/jsGLQIv0LkSTdX6M3Ra6HNzUYGpe49SxbaRlIX4/MrMMGVvVWtS050C3lP3hkJoZGyqjJD/g/qDdxIP7ApgyCyFNOK8rJ1pYbAZDZSSuJjyzDKgoh473ZCuqcDyf9UAUarC8=;
Message-ID: <71249.78658.qm@web37601.mail.mud.yahoo.com>
X-YMail-OSG: Iz2RtrQVM1ntwkQS754D_ceIkxwzRL_njxPmvwNyLS6DUSo
 mK8A4_mK_ekHHfuli._ZOYJ_wdE2Z9GDXLRsi6zBMI4SsuZQ4CDbeH_1Hl5R
 Qeq02.mreU1gs6M9OsSGAJpsLoeFEFDVngROB3UzkLOuXzQ86lm6io6bpsyC
 adBoRx7An4d2uNZFdQdu6YGIIljZqbLI3a97EW8slVzRzkfp5gzxp9UAkvEA
 fiwc8JQbbhbe9ThlvQd9M79X9dAgdVOXDOLHS3YcReT7tyXKCAxkRc2XN8uk
 kvUyCm5ODU2yrwF6FHZ2CGFIXMvTsZagRrpsYCIENigKtbHgQ1.jUNk.hjSg
 6jN1FpDXWbZMYWr5DbxJfAQsvNncFMMS4FSzk
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Mon, 25 Oct 2010 07:44:04 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 01/29] memstick: core: header cleanups
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Maxim Levitsky <maximlevitky@gmail.com>
In-Reply-To: <1287791637-10329-2-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> Received: Friday, 22 October, 2010, 4:53 PM
> * Replace the __attribute__((packed))
> with __packed

This introduces unnecessary noise and can be merged into a common clean-up
patch.

> * Add struct mspro_cmdex_argument, argument for
> MS_TPC_EX_SET_CMD
> * Increase size of inline buffer in memstick_request to 32
> because thats the size of registers and someone might need
> to read them
> all. That structure is allocated one per memstick host, so
> its size
> doesn't matter.

This functional changes are better be joined with the first patch which
actually requires them (these are just 4 lines).

> 
> * Add comments about few members of memstick_request

Belongs to the clean-up or a separate commenting patch.

> 
> Signed-off-by: Maxim Levitsky <maximlevitky@gmail.com>
> ---



      
