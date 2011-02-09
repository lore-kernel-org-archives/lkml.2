Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab1BIXEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 18:04:39 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36742
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750989Ab1BIXEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 18:04:39 -0500
Date: Wed, 09 Feb 2011 15:05:14 -0800 (PST)
Message-Id: <20110209.150514.115926470.davem@davemloft.net>
To: jidong.xiao@gmail.com
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: Can anyone explain "movl %eax %eax"?
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTimN2oM6E9E34fMffgtH81ZfYcGj6J5nnjGrxGfA@mail.gmail.com>
References: <AANLkTikA3MT=eeMKg58HyYZRswUR+PMhYW978HEc0sst@mail.gmail.com>
	<4D5315FB.8020004@zytor.com>
	<AANLkTimN2oM6E9E34fMffgtH81ZfYcGj6J5nnjGrxGfA@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jidong Xiao <jidong.xiao@gmail.com>
Date: Wed, 9 Feb 2011 18:02:09 -0500

> Oh, I see. Thank you. So similarly, the operation "xorl %eax,%eax" is
> used for the same reason, right? I see that appears in more files.

The xorl clears the entire register.
