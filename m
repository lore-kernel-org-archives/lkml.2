Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab0H1STl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 14:19:41 -0400
Received: from n2-vm1.bullet.mail.gq1.yahoo.com ([67.195.23.155]:40284 "HELO
	n2-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753169Ab0H1STk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 14:19:40 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 723139.45534.bm@omp127.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=AwV1Dg/EWjTakkngZym025kiSMN8M4ISCb42my5ar56xvUYlKU9MLyf9cy1vsl9+GBreLe8Ir+TcP03lbFuTNRia2j/ax4rFQ0PZNnKAy57tQv2SF6dYeS008KebjmlLWmpT2XSIWKIlPHAIg1w5e/HYWBcyr+3zQ/m07yb9jEU=;
Message-ID: <611014.87741.qm@web180303.mail.gq1.yahoo.com>
X-YMail-OSG: TKAtoasVM1lr11Nkksylx74ekev3UMNfxLeB0jPISygW605
 uO5wyJFCkLmzJo8N1G91ldPeVbIoBipGVhYBkbbCG62IcGviq0tmmamzWpvM
 0HL682Hy9M4x8oawisllFW1is0VBUOz_ldDhDESqgnseg8A2TM4Q6gLOJuv6
 ttG5PCjRWEXjdl3j562EQcV53.a_2IT6KhE2Fr4b_ujoJPWjqQJPFH3cgZ8G
 Yetlg1m23TD08wsNpMcb913fLd4RTtWnG.MzaHmYkapWCH4gW.iAM7u.aAhS
 Y3yJoWdUwnRf66kfzigK73URFuBz6YgCwnYx7VfEwmknJ70mWoul10N8mvb1
 fea2AlebJguWuFNh1
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Sat, 28 Aug 2010 11:19:39 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 2/7] drivers/usb/gadget: Remove double test
To: Julia Lawall <julia@diku.dk>, Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Thomas Dahlmann <dahlmann.thomas@arcor.de>,
        kernel-janitors@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-geode@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4C79435B.2030303@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Sat, 8/28/10, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> There is only a drawback if the subject
> is too broad /and/ > if the Cc list is
> too short; 

Not entirely true.  Recall that one of the roles
of the patch summary is serving as a search key
for Google or whatever ... changing it decouples patches from their discussion,  complicating
later troubleshooting (probably not in this
case, but for some patches, very much so).

- Dave


