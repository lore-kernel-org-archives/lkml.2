Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117Ab1F1Pfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:35:50 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:33476 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757706Ab1F1Pbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:31:48 -0400
Message-ID: <4E09F3F1.7080109@free-electrons.com>
Date: Tue, 28 Jun 2011 17:32:01 +0200
From: David Wagner <david.wagner@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Matthieu CASTET <matthieu.castet@parrot.com>
CC: "dedekind1@gmail.com" <dedekind1@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH] UBI: new module ubiblk: block layer on top of UBI
References: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com>	<1308922482-14967-2-git-send-email-david.wagner@free-electrons.com>	<1309202771.24805.11.camel@koala> <4E09EA52.8090006@parrot.com>
In-Reply-To: <4E09EA52.8090006@parrot.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2011 04:50 PM, Matthieu CASTET wrote:
> Hi,
>
[...]
> Also what are the advantage against gluebi + mtdblock_ro ?

The main advantage is a reduced number of layers ; I must say I cannot
see much more for now.  I could add that the Kconfig help of gluebi
advises not to use it except when needed by legacy software.

-- 
David Wagner, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
