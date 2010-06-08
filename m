Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab0FHOCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 10:02:11 -0400
Received: from n3-vm0.bullet.mail.gq1.yahoo.com ([67.195.23.156]:30496 "HELO
	n3-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755138Ab0FHOCJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 10:02:09 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 355810.84338.bm@omp119.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=OTCpV23T0xNJH+yuAN2Y9sjboiSmFpollDcYCUKeOWqlP3nLnzezKYktnjN3VylRagwL1Wh4xY7Wfvx/caut3z+F4QzJw979Bi4gJN+bgD/icL+OGduc9hrrMP3Yz7RXytbk6RvP8kq2S0fNT1BRAO8qKjPTzawduGO1laXV66E=;
Message-ID: <247687.51561.qm@web180316.mail.gq1.yahoo.com>
X-YMail-OSG: clXKY8kVM1nZ.zISMpX2ARAonLMueGdsMFQu40um09y.LBl
 jbsVH.U4bnz1ema.pRvqraeOKXxHwQKKILacoeJdsaKVkdM_sLo7R9F3RGw8
 _Lcfkh.tXLjPHCd2KZ84rIla6DVaXKEEI3__cp9RVvucMdFaj.MpLTcZ78Ww
 GLLD3EeUkbr7WFxe1jPjsYpf4x0iKKwwgVZQ3tQl_j7rydp1lODOeSLs9m_O
 PzpMUi2FqjLwt1aipz9KBdPalXpq_kQfGFqZYPq5MhgTH8A9MdjRa8Cc_HPM
 RQXlTUaomPt5LKwIVoFMP5UMqKIE_8Qw.r5JrKYyuxbbljdsMvhXs8B6rpnl
 4em4qYiCXG5i76U9pQedldJ9vtl0-
X-Mailer: YahooMailClassic/11.0.8 YahooMailWebService/0.8.103.269680
Date: Tue, 8 Jun 2010 07:02:06 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCHv4 11/13] USB: gadget: composite: addad disconnect callback
To: linux-usb@vger.kernel.org, Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <6999e11de09e1f7f1091ee43882a8fc75bf2aab3.1275906835.git.m.nazarewicz@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Mon, 6/7/10, Michal Nazarewicz <m.nazarewicz@samsung.com> wrote:

> From: Michal Nazarewicz <m.nazarewicz@samsung.com>
> Subject: [PATCHv4 11/13] USB: gadget: composite: addad disconnect callback
> To: linux-usb@vger.kernel.org, linux-usb@vger.kernel.org
> Cc: "David Brownell" <dbrownell@users.sourceforge.net>, "Kyungmin Park" <kyungmin.park@samsung.com>, "Marek Szyprowski" <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org
> Date: Monday, June 7, 2010, 5:39 AM
> Added a disconnect() callback to
> compasite devices which
> is called by composite glue when its disconnect callback
> is called by gadget.

Acked-by: David Brownell <dbrownell@users.sourceforge.net>


... though I don't recall why I didn't add
this originally; I certainly thought about it.

> 
> Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/usb/gadget/composite.c |    2 ++
>  include/linux/usb/composite.h  |    2 ++
>  2 files changed, 4 insertions(+), 0 deletions(-)
> 


