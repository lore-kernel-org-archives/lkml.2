Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab1JAVag (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 17:30:36 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:44484 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751007Ab1JAVa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 17:30:28 -0400
X-Sasl-enc: 4DvbjNi16kwVCpwV3xG8pBaWCsN4zusgq/iSF7fXLUsU 1317504627
Date: Sat, 1 Oct 2011 18:30:25 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Willy Tarreau <w@1wt.eu>
Cc: Steven Rostedt <rostedt@goodmis.org>, David Miller <davem@davemloft.net>,
        greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: kernel.org status: hints on how to check your machine for
 intrusion
Message-ID: <20111001213025.GF23355@khazad-dum.debian.net>
References: <20110930235924.GA25176@kroah.com>
 <20111001073533.GA18690@1wt.eu>
 <20111001180641.GD6309@home.goodmis.org>
 <20111001.141343.2293070262147973147.davem@davemloft.net>
 <1317493763.4588.70.camel@gandalf.stny.rr.com>
 <20111001183448.GD18690@1wt.eu>
 <20111001212321.GE23355@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111001212321.GE23355@khazad-dum.debian.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm, and a last tip:

Always use the "AllowUsers" or "AllowGroups" directive in sshd_config to
only allow access to whitelisted users/groups and deny to every other user
(including system ones).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
