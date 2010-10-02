Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614Ab0JBUUg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 16:20:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54168
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751345Ab0JBUUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 16:20:35 -0400
Date: Sat, 02 Oct 2010 13:20:56 -0700 (PDT)
Message-Id: <20101002.132056.226767861.davem@davemloft.net>
To: dhillf@gmail.com
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, robert.w.love@intel.com,
        James.Bottomley@suse.de
Subject: Re: Ask For Comment: add routines for exchanging data between sock
 buffer and scatter list
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTimF+zy-qTmbtchGu_0Td7fZUsrsd7PNgkAdM8fA@mail.gmail.com>
References: <AANLkTimF+zy-qTmbtchGu_0Td7fZUsrsd7PNgkAdM8fA@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


All networking related patch postings should be sent with
netdev@vger.kernel.org at least on the CC: list.
