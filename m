Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406Ab1JaJQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 05:16:12 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:54517 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932260Ab1JaJQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 05:16:11 -0400
X-Sasl-enc: X3MrnY/tPEhfjL9V4hhoTGRrUgbA7igVIrzK45Cptcp/ 1320052570
Date: Mon, 31 Oct 2011 07:16:07 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: HT (Hyper Threading) aware process scheduling doesn't work as
 it should
Message-ID: <20111031091607.GB7106@khazad-dum.debian.net>
References: <269467866.49093.1320004632156.JavaMail.mail@webmail17>
 <20111030212644.GA7106@khazad-dum.debian.net>
 <815860869.50724.1320011477430.JavaMail.mail@webmail17>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <815860869.50724.1320011477430.JavaMail.mail@webmail17>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Oct 2011, Artem S. Tashkinov wrote:
> > Please make sure both are set to 0.  If they were not 0 at the time you
> > ran your tests, please retest and report back.
> 
> That's 0 & 0 for me.

How idle is your system during the test?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
