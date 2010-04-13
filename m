Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651Ab0DMFBG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 01:01:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52067
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751355Ab0DMFBE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 01:01:04 -0400
Date: Mon, 12 Apr 2010 22:01:07 -0700 (PDT)
Message-Id: <20100412.220107.225635787.davem@davemloft.net>
To: thomas@mathtm.de
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       maciej.rutecki@gmail.com, rusty@rustcorp.com.au, mashirle@us.ibm.com,
       xma@us.ibm.com
Subject: Re: [Bug #15719] virtio_net causing kernel BUG when running under
 VirtualBox
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BC2ECE4.1020704@mathtm.de>
References: <4BC2DC5A.6090007@mathtm.de>
	<20100412.022828.52192543.davem@davemloft.net>
	<4BC2ECE4.1020704@mathtm.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Müller <thomas@mathtm.de>
Date: Mon, 12 Apr 2010 11:50:28 +0200

> I think I have to disagree.

Indeed you're right, net-2.6 needs it too.

Thanks for catching this, I've cherry picked the commit
from net-next-2.6 and added it to net-2.6

Thanks again!
