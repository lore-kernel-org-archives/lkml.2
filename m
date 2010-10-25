Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657Ab0JYPMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 11:12:20 -0400
Received: from web37604.mail.mud.yahoo.com ([209.191.87.87]:46363 "HELO
	web37604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751171Ab0JYPMT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 11:12:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=vIIMQcpnLgRlVcsts42kv0Iy+0apbii3va+0i31bRh+HQyfbCXBJ+3A/8VBMKA8jZCLfbbudQuQRfp/1Twc7D7VxilrHm9vM1Dec4+pP3oEw/pMpboQtfAOlUI5X3JCOhrFWyUlRm4fZow1CUHh2xEbxP8t3+8sF7ksHNQBHZQA=;
Message-ID: <785156.30720.qm@web37604.mail.mud.yahoo.com>
X-YMail-OSG: Kwx7LRwVM1nNQ4yFaIl.NO80Ud7Z7CheKh_z6O3cN63yKzJ
 AUFVsz2U5tqQGqyk7I9W2DL9qdCUhxLRXd8rzLIJYqTgnvrYP5C.eWULBd1U
 K7KmyGbCnNyz9VkP7YLnpCqQb7F14DkoPYQJItQ3WJpt_th4OpU21Ctujqm.
 xx07Sbq0F536MpyUzbHxNEh.kM4syPTgxczEBtjVf1f.ie84iWUItzy7NZ3e
 gs6cLtYrnqEaJK6WSo_jodZwHlq6vFd8hVGpiHOpYmvRytLixNrYlrTh_lHA
 Xs_OddNgBaevv.XTUi_IzLtFHlP1DDsgFJ7D4KtOcFgsPMly69rvz1c9UUbX
 I2GVrE0iM3ZxwXzsl7uqruAkEcWoKBWznrkSzVn48VN83lBLu
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Mon, 25 Oct 2010 08:12:18 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 06/29] memstick: mspro: kill the BKL
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
In-Reply-To: <1287791637-10329-7-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Subject: [PATCH 06/29] memstick: mspro: kill the BKL
> To: "Alex Dubov" <oakad@yahoo.com>
> Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> Received: Friday, 22 October, 2010, 4:53 PM
> mspro_block_disk_lock already
> protects the code.
> 

It is indeed, but I don't see the functionality this patch is trying to
revert neither in my running kernel (2.6.32.8) nor in current git tree.



      
