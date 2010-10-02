Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab0JBXyZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 19:54:25 -0400
Received: from web53706.mail.re2.yahoo.com ([206.190.37.27]:20017 "HELO
	web53706.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752000Ab0JBXyY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 19:54:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=a1LtYIPNSPmudQ15WkNfiitghncI/l3Ewrm+XfphD6ENzV3jhQX+5qUIplymHw8qlBIGC4yN54yr6Bf+0wGoOUuBcRN3iZq17obDE9gm/7uoCHCktGnqi0W2USBvrpgR3bTTn0iDz+GU5nZfNhFh9MmrrGnRYb8KJG6UI49WDzA=;
Message-ID: <970819.25375.qm@web53706.mail.re2.yahoo.com>
X-YMail-OSG: 5DJaiGwVM1kVuHnYOG9I8ikLUmwlgDvydyOmGc8mnqmtGqo
 sENb8P11X8xTI7ZOcM_8AnwvFgKy49YqmEZLBPhdVByYSWQoLkQJ7UrscDpV
 4kMBNr0VtyKzdiGAPYItW_ZNJJJvnLnPfYRojno6aDxrFvBTApNEiAxxZNan
 xXKUNF8swbSY1AdOtBwTkZ7be1e3lS10HIH3ZP4bYq1RV9_eTNmwMkuITNF.
 5bWaQVHi62mUa5Qab1KjXgIBE363goV3Dsd7_toUp7YdhGDOApkREhihYvwI
 _UI7Z01WycGHjnoVI4BMYK2kI6dqJChYMafqv9DsiI8zJNj5mVJFf4PXgfql
 L8IBD
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.105.279950
Date: Sat, 2 Oct 2010 16:54:23 -0700 (PDT)
From: Nagendra Tomar <tomer_iisc@yahoo.com>
Subject: Re: [PATCH 1/2] net: Fix the condition passed to sk_wait_event()
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101002.132659.71124680.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,
     I had done the exercise of sending the patch to myself and applying it (copy-pasting just the patch). One thing that I see is the long line in the description. If you are referring to that, I've fixed it and submitted it again. If not this, I'm at loss.

Thanks,
Tomar

--- On Sun, 3/10/10, David Miller <davem@davemloft.net> wrote:

> From: David Miller <davem@davemloft.net>
> Subject: Re: [PATCH 1/2] net: Fix the condition passed to sk_wait_event()
> To: tomer_iisc@yahoo.com
> Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
> Date: Sunday, 3 October, 2010, 1:56
> 
> Your patch is still corrupted, your email client is
> splitting up
> long lines.
> 
> Please, save us a lot of time by test emailing the patch to
> yourself,
> and then trying to apply the patch as you receive it. 
> Do this until
> you're fixed all of the formatting problems and then you
> can send it
> here.
> 
> Do not resend the patch by simply replying again to this
> thread,
> send a fresh posting so that "Re: " doesn't show up in the
> subject
> and this way I can apply it directly without any editing.
> 
> Thank you.
> 


      
