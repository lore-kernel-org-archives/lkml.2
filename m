Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935413Ab0HFH7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 03:59:13 -0400
Received: from web37606.mail.mud.yahoo.com ([209.191.87.89]:36786 "HELO
	web37606.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933853Ab0HFH7K convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 03:59:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=K3oRvN5YYkYUifm+eSoDjDksWNafWjDeNjkayuW+p5lNQbtiv7HHA9TTwu0Kw1N480jw+khLO2Jml1ka7Iggz2L4LfPMIiiMTnr6mKidvbRQCBpcIBjl/8mcdPAU0tl8RsZG7IXT7dL6H7xIJNFn6jjRzXCBxfcqK0LKfbtXpIg=;
Message-ID: <209536.68480.qm@web37606.mail.mud.yahoo.com>
X-YMail-OSG: KPJ10scVM1mOoVAXVHJkxT4S2G_lMdvZ47IB3_DObkKpiFm
 ek27TRoSEzSF0coiOxidddFYFnAtraq5d022DxYMmcCbvAD0T9ebQbKO62CE
 KUWa.LebGm.yHKAgENAOrLtWypOPI9Zk8O2xl_rnDV5QI_CBFsUeY3LVfrWO
 leSIY9S3m6AhX35Z6Beq9.hhyo6TAvOenv5zNDwjouopiPm6yduRMdJmefZX
 rrbs8uv03MgtzewkB24Ru3Lk5qE994Q8afk9OpqvZzpj8LdDPhOX7baV2qIR
 jt8U0S0nuyd.I.VcQKHmI.ff5A8fsdaAWx5wTVPQ-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Fri, 6 Aug 2010 00:59:07 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1281012396.9324.29.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Btw, I want to add a callback from driver to card driver to
> be able to
> reset card in case of error (windows driver does that in
> case of any
> error)
> 
> I would use most of the mspro_block_resume for the
> implementation for
> mspro.
> 
> Any objections, suggestions?
> 

Just toggle a power on it. Power off/power on will do the full reset of
the controller and the media. You don't have to reinitialize it, as you
are sure that it's the same stick.




      
