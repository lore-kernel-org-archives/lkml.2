Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542Ab2CBJO0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 04:14:26 -0500
Received: from mail.southpole.se ([193.12.106.18]:39334 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045Ab2CBJOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 04:14:22 -0500
Message-ID: <1330679663.32213.62.camel@crucifix>
Subject: Re: [PATCH 3/5] OpenRISC: Export memory_start and memory_end
From: Jonas Bonn <jonas@southpole.se>
To: Richard Weinberger <richard@nod.at>
Cc: linux@openrisc.net, linux-kernel@vger.kernel.org
Date: Fri, 02 Mar 2012 10:14:23 +0100
In-Reply-To: <4F508962.1070108@nod.at>
References: <1330649715-32438-1-git-send-email-richard@nod.at>
	  <1330649715-32438-3-git-send-email-richard@nod.at>
	 <1330671102.19557.100.camel@satguru> <4F508962.1070108@nod.at>
Organization: South Pole AB
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 79660-10333
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2012-03-02 at 09:48 +0100, Richard Weinberger wrote:
> Am 02.03.2012 07:51, schrieb Jonas Bonn:
> > On Fri, 2012-03-02 at 01:55 +0100, Richard Weinberger wrote:
> >> At least virt_addr_valid() makes use of memory_end.
> > 
> > virt_addr_valid looks broken... it shouldn't be comparing a virtual
> > address against memory_end which is phys_addr_t.
> 
> Then it's time to implement it correctly and match OpenRISC's
> semantics.
> 

Give this a try...

http://git.openrisc.net/cgit.cgi/jonas/linux/commit/?id=30fbeb350cd26dc87477b9cadf0bfe132dcf5119

/Jonas

