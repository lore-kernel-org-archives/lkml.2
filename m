Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab1F1KA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 06:00:58 -0400
Received: from nm19.bullet.mail.ird.yahoo.com ([77.238.189.76]:46776 "HELO
	nm19.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756261Ab1F1J7y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 05:59:54 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 932138.43791.bm@omp1027.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Ma3wvAHVJIa8pl/0jPr+zkQPFkeukUcpfKhf4hPh1EjkBwHm7Sp/4EVgMkrJlH6XEhlBcwKUzXMhR/O9bzgHdHo2luzhQsx2YwwRSjUYXlvPRl4boaDrNqVwAGNLUlDWqU5YGqIY+TLxHUgj2iwAzhzp+nx2AcX7OHygIssC9vc=;
X-YMail-OSG: 5mekTXUVM1mwWTgfWYWYxCrbA2dotA8YMQi0EhnLnkZDNoz
 GQeg6rDE0pb9LMrXx05URxhWkttTzvjVdSRepIfnHuHHO21VnRjO1Gh6CjJK
 _htpzkABLM2DBExMbbYlXo0zzoQkNFYp4i2k_zXSU_nXwTyUw.tAf5_GU0GE
 rj60RtAVdxopVu28EEQs9bIj0T4wX_Wr0VqMsiXciNpybR0CGKPdgmGSRYfW
 jfIZAU22Ol0clumo5MP2I1hut3VN0_MtJw9FRgxkPTRBJIPuz3EUXJ3X.2kw
 F8RevLI2T2Sgc12q0C4nvJzLGP6dUhj94oqHClV32KMdqDdUsUAA2dKXH7H7
 zIw73OTKeP1cQQZZGDu52VJdkjrE-
X-Mailer: YahooMailClassic/14.0.3 YahooMailWebService/0.8.112.307740
Message-ID: <1309255192.86313.YahooMailClassic@web29002.mail.ird.yahoo.com>
Date: Tue, 28 Jun 2011 10:59:52 +0100 (BST)
From: Paul Parsons <lost.distance@yahoo.com>
Subject: Re: [PATCH] w1: ds1wm: add a reset recovery parameter
To: linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Jean-Fran=E7ois_Dagenais?= <dagenaisj@sonatest.com>
Cc: johnpol@2ka.mipt.ru
In-Reply-To: <4D9136CA-90AC-4DBB-9AD1-44062FFCF9D4@sonatest.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Jean-François; that patch set has resolved the problem.

Tested-by: Paul Parsons <lost.distance@yahoo.com>

--- On Mon, 27/6/11, Jean-François Dagenais <dagenaisj@sonatest.com> wrote:

> From: Jean-François Dagenais <dagenaisj@sonatest.com>
> Subject: [PATCH] w1: ds1wm: add a reset recovery parameter
> To: linux-kernel@vger.kernel.org
> Cc: johnpol@2ka.mipt.ru, "Paul Parsons" <lost.distance@yahoo.com>
> Date: Monday, 27 June, 2011, 14:17
> This follows the regression on 3.0
> reported by Paul Parsons regarding
> the removal of the msleep(1) in the ds1wm_reset() function.
> This
> sleep should not be required on normal circuitry provided
> the
> pull-ups on the bus are correctly adapted to the slaves.
> Unfortunately, this is not always the case. The sleep is
> restored
> but as a parameter to the probe function in the pdata.
> ---
>  drivers/mfd/asic3.c        | 
>   1 +
>  drivers/mfd/htc-pasic3.c   |    1
> +
>  drivers/w1/masters/ds1wm.c |    5 +++++
>  include/linux/mfd/ds1wm.h  |    7 +++++++
>  4 files changed, 14 insertions(+), 0 deletions(-)

