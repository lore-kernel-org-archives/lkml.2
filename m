Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab0GDExV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 00:53:21 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:39055 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753154Ab0GDExU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 00:53:20 -0400
X-Sasl-enc: M1TGHpTUFdLIjzgNkuaSKc7a0l0wbMsTeT2BZ2TzrsCX 1278219199
Date: Sun, 4 Jul 2010 01:53:15 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jerome Lacoste <jerome.lacoste@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: i8042 no mouse on resume. (i8042: failed to resume active
 multiplexor, mouse won't work.)
Message-ID: <20100704045315.GA7836@khazad-dum.debian.net>
References: <AANLkTilvxV18Qc2-34GtNmfAIvNL2dtEAPC3iPFNU2Pv@mail.gmail.com>
 <20100701162454.GD4152@core.coreip.homeip.net>
 <AANLkTikx8AxRdPoSbsym9rUiA11BbufqImcD2sg4f8Ds@mail.gmail.com>
 <AANLkTikmcaQSNNy6ZHMvEwBJVkWdyQ5KALR6832hUkjz@mail.gmail.com>
 <20100701224235.GA29504@core.coreip.homeip.net>
 <AANLkTilPJ6Vod4zU4gfOC3id-Cxy_Ho4I5lxMh5fLaCV@mail.gmail.com>
 <20100703212015.GA32052@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100703212015.GA32052@core.coreip.homeip.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Won't this cause an extra delay on resume to everyone who has a device
with proper firmware?

Would it be possible to reset the i8042 only if failures to bring the
active multiplexer are detected?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
