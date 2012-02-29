Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab2B2Isb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 03:48:31 -0500
Received: from mail.southpole.se ([193.12.106.18]:59871 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815Ab2B2Isa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 03:48:30 -0500
Message-ID: <1330505308.2964.24.camel@crucifix>
Subject: Re: [PATCH 1/2] OpenRISC: Fix audit_syscall_exit() usage
From: Jonas Bonn <jonas@southpole.se>
To: Richard Weinberger <richard@nod.at>
Cc: arnd@arndb.de, linux@openrisc.net, linux-kernel@vger.kernel.org
Date: Wed, 29 Feb 2012 09:48:28 +0100
In-Reply-To: <4F4DE30B.4060506@nod.at>
References: <1330476393-14264-1-git-send-email-richard@nod.at>
	 <1330501592.2964.1.camel@crucifix> <4F4DE30B.4060506@nod.at>
Organization: South Pole AB
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 05308-07725
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2012-02-29 at 09:34 +0100, Richard Weinberger wrote:
> Am 29.02.2012 08:46, schrieb Jonas Bonn:
> > 
> > Thanks, Richard.  There is, however, already a patch in linux-next that
> > provides this fix.
> 
> No problem.
> Why is the fix not in Linus' tree?

I have no good excuse... will send a pull request in short order.

/Jonas

