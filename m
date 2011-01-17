Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751136Ab1AQFdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 00:33:06 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41792
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750744Ab1AQFdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 00:33:04 -0500
Date: Sun, 16 Jan 2011 21:33:36 -0800 (PST)
Message-Id: <20110116.213336.102559857.davem@davemloft.net>
To: rdreier@cisco.com
Cc: error27@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: question about smatch error
From: David Miller <davem@davemloft.net>
In-Reply-To: <adar5ccyver.fsf@cisco.com>
References: <adar5ccyver.fsf@cisco.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <rdreier@cisco.com>
Date: Sun, 16 Jan 2011 21:02:52 -0800

> where eui is a u8*, and I don't see how smatch even thinks it knows how
> big the buffer is in the first place.

It can see that the one and only caller passes in a pointer in the
middle of an on-stack ib_gid struct, and it knows how big those
objects are.

