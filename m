Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab0DLJ20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 05:28:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52837
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753148Ab0DLJ2Y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 05:28:24 -0400
Date: Mon, 12 Apr 2010 02:28:28 -0700 (PDT)
Message-Id: <20100412.022828.52192543.davem@davemloft.net>
To: thomas@mathtm.de
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       maciej.rutecki@gmail.com, rusty@rustcorp.com.au, mashirle@us.ibm.com,
       xma@us.ibm.com
Subject: Re: [Bug #15719] virtio_net causing kernel BUG when running under
 VirtualBox
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BC2DC5A.6090007@mathtm.de>
References: <6Pphclm24fK.A.lSF.qsPvLB@chimera>
	<JVS2s9dmTsP.A.6eF.xsPvLB@chimera>
	<4BC2DC5A.6090007@mathtm.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Müller <thomas@mathtm.de>
Date: Mon, 12 Apr 2010 10:39:54 +0200

> Hi,
> 
> a fix (commit 2c45cd43ff791cc4ab6a6332165ad53d7bcb3673) is included in
> linux-next and net-next, but not (yet?) in linux-2.6.

This bug was only present in -next and net-next-2.6 to the best of
my knowledge, so the fix only showing up there is appropriate.
