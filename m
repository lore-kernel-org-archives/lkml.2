Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab0CSAAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 20:00:48 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:54976 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751704Ab0CSAAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 20:00:46 -0400
X-Sasl-enc: nb8CSe/qcXKbjhd4+7wPf3a3vsqwWXL41yjrKnUfvvt1 1268956846
Date: Thu, 18 Mar 2010 21:00:43 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linux Input <linux-input@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [RFC] Input: implement sysrq as an input handler
Message-ID: <20100319000043.GC12017@khazad-dum.debian.net>
References: <20100317061952.GA19789@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100317061952.GA19789@core.coreip.homeip.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any chance of the user being able to avoid the SysRQ events getting to the
handle, e.g. by opening the input device in exclusive mode or something like
that?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
