Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab0JYP6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 11:58:43 -0400
Received: from web37604.mail.mud.yahoo.com ([209.191.87.87]:48988 "HELO
	web37604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751518Ab0JYP6m convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 11:58:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=tFsBwbQDHWkelaw5VtwBiOSP6daIVai1cUETQpKPHgmwFgZLByquKWOeANZicjWRAKBsqlnPiWLHoT2cGkFEoafJkQia5Ca2m18UiwOdYsQEKfXe0fTK7WRZOaLmMeRM94tzgkM91cu6qlB4+eOcj/jLPFjsHZz4qSv9qbCeymw=;
Message-ID: <502046.56920.qm@web37604.mail.mud.yahoo.com>
X-YMail-OSG: SXYEGC0VM1mDziVuDa7oLJHVfDWtzIoVmXRKrS2ijH5Igeb
 MNF65FUuXWkGASL1fGZElz7Yw2eM.t68E4UVOW0PW5zpB5GDQgs3BCZC1lOT
 rS7v_CGZdtKlHq2MmAAzykZUTtb5ASR8oofs9JyQWdC0UX_YVeolBIcprWhT
 IuUErIG6rgJPNNfksaQFROu3x9djfqR7E9JeiUWlgUbbD.rEM3qLilJcOrvz
 ixPigUcVpTIw0IbcJACtkNuotQVcoGU6qy.S2jFL5MzpFw5TdcUkszvjQnu_
 OgjJ15O_J7TrmymkIgY_llIP27a2mrO8kSXeUdgVI_rPyL6ceCjk8MEX9lw_
 UH0b23M5fftrCOhU8B0JE_g--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Mon, 25 Oct 2010 08:58:41 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 16/29] memstick: jmb38x_ms: s/jmb38x_ms/j38ms/g
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
In-Reply-To: <1287791637-10329-17-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Subject: [PATCH 16/29] memstick: jmb38x_ms: s/jmb38x_ms/j38ms/g
> To: "Alex Dubov" <oakad@yahoo.com>
> Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> Received: Friday, 22 October, 2010, 4:53 PM
> This just makes it easier to type
> function names
> while still keeping the meaning
> Driver name and filenames are left unchanged.
> 
> 
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> ---

What sort of patch/argument is this?
Function prefix should match the module name, to be immediately and
unambiguously identifiable in the stack trace.



      
