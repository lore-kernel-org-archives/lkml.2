Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab0JYQRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 12:17:06 -0400
Received: from web37606.mail.mud.yahoo.com ([209.191.87.89]:45631 "HELO
	web37606.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751487Ab0JYQRF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 12:17:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Q9oeHIOqiH1GS4Tk7ikf1+ENlhQaaBGg6GSaZxolkIfFFi1VSMbGb9uonnvziqiFhJRqggnV8jxouEAxgSzXVBJGiWR9wTuB01mHe9HBYtNPc4FF7KJeREIYq/qFRm+iCuWTRRYwFdsyMKm80kV0D8Fc82lewKLgtcVTlsFZf5c=;
Message-ID: <383799.30120.qm@web37606.mail.mud.yahoo.com>
X-YMail-OSG: 4Xrbe9kVM1mYUnswuv3R50CmqN7yDNbj9QbQATF4XBfzSku
 YAeaXEEwWHZgOjNAGFXH27YhbZpv8q9n9VQEUnADlPNHJnqHlddeCbF_Lcof
 pm2Y0NpsuaJpQOr406uc_kW3lNRon_ZtvnUYwEiFMHDWh2l0A21hPwjvDETW
 BXGnMqAAqz49axlT9OTwbFlOmt2zyQxs5DPJOfwcE_ZdUc0wuYsfHpnRyQF3
 NLbiiVgD4166kiAIwpobQliPKa7BiJk9YU2.jyQVkvDF.61E6a8Yvtt5avHe
 EnPqfCXV2UgqDMC63tRXAiDyjNn59DgJ69AQcKhU6qmu1b3GNP54S6ZcvdOd
 754OWff8fiTge6YL1_aXSeivXXBN0pvfDIEkenRn7QMmb6K2f
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Mon, 25 Oct 2010 09:17:04 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 26/29] memstick: jmb38x_ms: rework hardware setup/reset
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
In-Reply-To: <1287791637-10329-27-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Subject: [PATCH 26/29] memstick: jmb38x_ms: rework hardware setup/reset
> To: "Alex Dubov" <oakad@yahoo.com>
> Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> Received: Friday, 22 October, 2010, 4:53 PM
> Move the code into functions.
> Reset clock on init - fixes serial mode
> 
> Signed-off-by: Maxim Levitsky<maximlevitsky@gmail.com>
> ---

Ok.



      
