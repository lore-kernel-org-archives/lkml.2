Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab0JYP1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 11:27:30 -0400
Received: from web37604.mail.mud.yahoo.com ([209.191.87.87]:25883 "HELO
	web37604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751483Ab0JYP13 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 11:27:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=JdORqpM70X4YSaeHcK469o52wAzx66XuYXdr+Tp8lW1pOyHZUVthukWgZJX+ssrnGkZmhwDzY4jjMm4IccjntzSzuOya43+vHWonK3T/qh/w3jMbnPEnJzFYwSAKBerObdLfBH3FNtnYFRtqn+vgn58806/j/e6SCHumMtabDec=;
Message-ID: <518013.36245.qm@web37604.mail.mud.yahoo.com>
X-YMail-OSG: d2LeRucVM1mbfxdSx2F5y1JLJrsXWtw.39M_CDtXscY.gSG
 XltaDDEw5e8Oor60SBifzKv73d9X2CiAnjhw2FQweZGlwTVYLKAFCiuGfVlv
 Bi0vdeOGr09TQXjBCQ5kmm6ZRcNDMMfizXzZIPOO960IQ3RFHb1SkaTfcfiI
 h5vq4lSgFRCVIy.zlL1wPwwzLvOrbWLj9QKrR9xFtCxxjQ1q6AlHFR0Y7kY8
 8T00dj_NMTZu8Fb2wl93Vjl8iPzosDH5W5yTJd4ZuQrUFreQvGQK0ky7haJe
 Mk_pXd_qAbiWNJ9xi7PaAlmIxVPRXfT4RzIEG7gzM2jRnbOF4J_.nSlDWSDB
 Ds5IjT9QIGEhEpAuN4f57MGQWXIC6Txm7IMfQZksgYrYE30RUAw--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Mon, 25 Oct 2010 08:27:28 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 11/29] memstick: mspro: use MS_TPC_EX_SET_CMD
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
In-Reply-To: <1287791637-10329-12-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Subject: [PATCH 11/29] memstick: mspro: use MS_TPC_EX_SET_CMD
> To: "Alex Dubov" <oakad@yahoo.com>
> Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> Received: Friday, 22 October, 2010, 4:53 PM
> This little optimization done by Sony
> for
> PRO variant of the cards allows to bundle the param
> register
> with the command and therefore send one TPC less.
> 
> This increases IO throughput somewhat.
> (4.4 -> 4.8 MB/s on Jmicron for example)
> 

1. Names for states.
2. Coding style.
3. Introduction of struct mspro_cmdex_argument belongs to this patch.





      
