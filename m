Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab1IFPE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 11:04:26 -0400
Received: from ist.d-labs.de ([213.239.218.44]:56072 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754780Ab1IFPER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 11:04:17 -0400
Date: Tue, 6 Sep 2011 17:03:43 +0200
From: Florian Mickler <florian@mickler.org>
To: mcarlson@broadcom.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, benli@broadcom.com,
        mchan@broadcom.com, davem@davemloft.net,
        Francesco Piccinno <stack.box@gmail.com>
Subject: re add support for bcm5750
Message-ID: <20110906170343.09252578@schatten.dmk.lab>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
In-Reply-To: <1280784368-4226-8-git-send-email-mcarlson@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

in https://bugzilla.kernel.org/show_bug.cgi?id=42132 Francesco wrote: 

> I have a notebook (HP TC4400) which has a BCM5750 ethernet card inside. The
> ouput of lspci is:
> 
> 08:00.0 Ethernet controller [0200]: Broadcom Corporation NetXtreme BCM5750M
> Gigabit Ethernet [14e4:167c]
> 
> Commit 67b284d476bcb3d100e946da23d6cf9acfd0465c removed the support for this
> device. I wish to have the support for this network card back again. Thanks!

Regards,
Flo
