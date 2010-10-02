Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab0JBLtW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 07:49:22 -0400
Received: from web53703.mail.re2.yahoo.com ([206.190.37.24]:24304 "HELO
	web53703.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753236Ab0JBLtV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 07:49:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=iqBIpbzAs2ymIoxYS0Tq+mrKzsklJ1twYswHST1G0K3A802A2qrxvJ3rOvCO1bfMTrKS1tUtQJxjChcSVzvawuo4nY7Mzpqczu8DwNjokMguVbTRJnKAxrvINjvQGH17czi6l6exh5hhGzf/5SkrNYfjTgBq3IL9dSr7vsI91fU=;
Message-ID: <786890.87789.qm@web53703.mail.re2.yahoo.com>
X-YMail-OSG: 8dZrG5cVM1kuW4z92pzH8SwirKythjRzZG7INQNlfK7ucMh
 pbpkuPpPl7Utm21q3qzE6XA8X6f..CZBLzFYLt3J3L2Y6ocWp.gqAIzlCcDj
 p7DC29LBT90xYAwdXFUcHZoeQRDLMAJHc8hoWlRX_JPGieSQvH9ncG5E2ZhY
 rqqGCpGCk6RV8NzrPdnIUgmouBwb9IY.EAy4A41SAgqN8.BQfKbWK2KuoH1G
 ubq9o7FlDfQc1oqCk6c3yjBwjgaulprq1ukons1WkrnGRwgOH02mmAddhIF5
 NbDYvktFsnUYPlzLmXfjtn8GqxjIb5jRP9Mibe.7LU6tU6WI3cL2_ml5cATE
 FU2qVvB4a
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.105.279950
Date: Sat, 2 Oct 2010 04:49:20 -0700 (PDT)
From: Nagendra Tomar <tomer_iisc@yahoo.com>
Subject: Re: [PATCH 2.6.35.7] net: Fix the condition passed to sk_wait_event()
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, linux-kernel@vger.kernel.org
In-Reply-To: <1286008441.2582.851.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Sat, 2/10/10, Eric Dumazet <eric.dumazet@gmail.com> wrote:

> > Just wondering why you remove the test on sk->err
> ?
> > 
> > We want to break the loop If sk->sk_err is set, or
> state is ESTABLISHED
> > or CLOSE_WAIT.
> 
> Hmm, reading the code again, I can see sk_err is tested in
> the loop, so
> your code is better (sk_stream_wait_connect() returns an
> error after
> your patch, instead of returning 0)

Exactly.

> 
> Could you please split your patch in two patches ?
> 

ok, I'll send it soon.

Thanks,
Tomar




      
