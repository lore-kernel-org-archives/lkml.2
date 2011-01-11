Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab1AKCst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 21:48:49 -0500
Received: from web37603.mail.mud.yahoo.com ([209.191.87.86]:40223 "HELO
	web37603.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753150Ab1AKCso convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 21:48:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Syuo2OKPUlFck8AxruM7RyS+Tlzn2yE35dO+XjLeG3OdBEF6hI8shc1dahzLEQ7KMbi1Jd6ufzfxJkTz1sI3dZiAaKERxdMeejdT3UaEItV0Was0QSKnHPimUb25UZxP3DG9QAUlSCdl5RULDuVaGPCqUhbodLYKmdETDG3CRek=;
Message-ID: <757175.38063.qm@web37603.mail.mud.yahoo.com>
X-YMail-OSG: aOYNkQYVM1lO2IVHrGtBjqAhM_Mp6FCxJbGWJt7XC3LC2yl
 SmB.vFUHOGOeDa_xJ23PHd.7Yk07JvY8ojC4xI8kj1gyQRKNSp_X8JguzINk
 m2A1nK5qVqMpDZE6Ennp1hYork298_f3ZU1iKghMw7.wTLrYdUi_N1IBRjOm
 OQfGaEDJA3J5wqj4z6FYJA2aQaT.eA23VsndcmofAU_c4zQ3FGYmaoW1evBp
 WO3G6Pb.06dShZtsB23H7w4h3G2jFz78RUz12OKIKUasJGcAsF.0aeL.dW35
 NiH5.VIIxolpwaCoLfyQk2cHdIfFSHRDxrANtdrgWx5VYuuMIJU9h9MHTQJA
 JpiuKx02cvshZZIQFn8cOSJYIBYlcPhfEJdiQoeIHcLBzqDguE3tmMXqnGFw
 JS06esaXcYow-
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Mon, 10 Jan 2011 18:48:43 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 3/4] memstick: add support for legacy memorysticks
To: Andrew Morton <akpm@linux-foundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>
In-Reply-To: <1294710624-12379-4-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +
> +    case 2: /* send INT request */
> +        if
> (msb_read_int_reg(msb, -1))
> +           
> break;
> +        msb->state++;
> +
> +    case 3: /* get result of the INT

I still think it would look nicer if you could name your state with explicit
names and use "next_state()" or something to move on, instead of just
incrementing it.
Otherwise, I have no principal objections.



      
