Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab0JYPNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 11:13:44 -0400
Received: from web37604.mail.mud.yahoo.com ([209.191.87.87]:47227 "HELO
	web37604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751241Ab0JYPNn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 11:13:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=RTyEWRsVnDtBgAI0SPOZEIrhH0fjFg1toOj7h33ecGvYax5+wFWAghfDQXpy09K1vDGo4z/A7ZJFvCizW9CHoRT0ryDHXFkc1bCV7Xu2LFHjJl7YOnPN0WkrcefVHDYJGz9FzuLnG0eIZTbPkEpYAxzkHuctZmUUSjhJBh3D8ig=;
Message-ID: <915551.30341.qm@web37604.mail.mud.yahoo.com>
X-YMail-OSG: O.RM58cVM1lXrBFlYkv2ZOOI0s81o4IStqKbiFNSGJFU72a
 _mAYEjyoyP54iYfzES9vNfLtZR7aC2DyWT1SgM8t_8uMaeRGs3UG5m_hMAag
 ltJzDBkO_1XHVEvxImds_a7BtgnhZX9RDF6l__PeOupGjo.TgkE_k2d2R59N
 sWmQnGiNOdV6XlqlxwcxPpIJLSoP2RORvNNzx1ije5k7SuHdWh5rtJxWH2Pf
 yN3gfSy.tx.KnErcwAJc4cBFWZ8vMgFlIZIaggLECosLJwqfExuQeROMS3X3
 cTmVfwJeEoyBukiHtsU9cyF54upjaXxWYgQ4g3i2Uxo2lWfjKdzPIRR5NehI
 uxCKR88j5oMH.SVpXnrlf4CqYmiDmpEWz9Phct_u34MpTYD1t
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Mon, 25 Oct 2010 08:13:40 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 07/29] memstick: mspro: two fixes
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
In-Reply-To: <1287791637-10329-8-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Subject: [PATCH 07/29] memstick: mspro: two fixes
> To: "Alex Dubov" <oakad@yahoo.com>
> Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> Received: Friday, 22 October, 2010, 4:53 PM
> fix uninitialized spinlock warning on
> resume
> and race in idr_pre_get
> 

I fully agree.

Coding style!



      
