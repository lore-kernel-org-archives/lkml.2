Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab1HJOBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 10:01:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:38528 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab1HJOBa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 10:01:30 -0400
Subject: Re: [PATCH] 8250: Fix compiler warning
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20110804194520.5a3dbd38@pyx>
Date: Wed, 10 Aug 2011 09:01:18 -0500
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <225E012C-3134-4F86-A130-B205145D3E18@kernel.crashing.org>
References: <1312445581-16283-1-git-send-email-galak@kernel.crashing.org> <20110804194520.5a3dbd38@pyx>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 4, 2011, at 1:45 PM, Alan Cox wrote:

> On Thu,  4 Aug 2011 03:13:01 -0500
> Kumar Gala <galak@kernel.crashing.org> wrote:
> 
>> drivers/tty/serial/8250.c: In function 'serial8250_shutdown':
>> drivers/tty/serial/8250.c:1775:19: warning: 'i' may be used uninitialized in this function
> 
> NAK, as with all the previous nacks of this.
> 
> Use a newer gcc - modern gcc gets it right.

How modern? Building with a gcc 4.5.x

- k