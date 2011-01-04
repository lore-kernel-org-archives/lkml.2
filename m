Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635Ab1ADSP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 13:15:57 -0500
Received: from web31813.mail.mud.yahoo.com ([68.142.207.76]:27340 "HELO
	web31813.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751317Ab1ADSPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 13:15:55 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=audLovxZyJlOWcz6xJitFzjFDH/5V+I8XrxDBkOEBxpyQIxhu1tFsIoN8I0K607UyyTD7/G6JyOqJ1sO5A265dmBqhOadc6S4Z4Dus2lyTUzFX4kQhmj55YVQ5vrz5PxiVPK4ocV1A8lcEgSiQ5ADGyvlmq5CJh6jr9Eg6yoLjQ=;
Message-ID: <914550.72241.qm@web31813.mail.mud.yahoo.com>
X-YMail-OSG: pXAD61IVM1knpj7CfAohj_Ty_Fe4hS4PBUZIA4b2b8XrsRo
 JBHHVvLMA
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.108.291010
Date: Tue, 4 Jan 2011 10:15:53 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: UASP updates (uasp.c)
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are the updates you can find at https://github.com/ltuikov/linux-2.6:

commit 7b725e4ffa88490cb2bb042a703644f75bcd52b9
Author: Luben Tuikov <ltuikov@yahoo.com>
Date:   Mon Jan 3 16:26:23 2011 -0800

    [USB] UASP: Updates
    
    * Free the RESPONSE IU URB if unused, i.e. a
      status urb was never used due to the failing
      command.
    * Make some debug messages clearer.
    * REQ_HARDBARRIER no longer exists--update.
    * scsi_host::queuecommand changed prototype--update.
    
    Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>

commit 58f76dfb08d155644ed639a319677c5dd9e11f16
Author: Luben Tuikov <ltuikov@yahoo.com>
Date:   Mon Jan 3 15:38:21 2011 -0800

    [USB] UASP: Remove conflict markers in Makefile
    
    Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>

commit 1a15005eeb46c10067354b492ac73f09305c3e6b
Author: Luben Tuikov <ltuikov@yahoo.com>
Date:   Mon Jan 3 15:11:14 2011 -0800

    [USB] UASP: Remove confict markers in Kconfig
    
    Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>

