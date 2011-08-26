Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab1HZOoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 10:44:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61280 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab1HZOod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 10:44:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        ulrich.weigand@linaro.org
Subject: Re: try_to_freeze() called with IRQs disabled on ARM
Date: Fri, 26 Aug 2011 16:44:26 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Tejun Heo <tj@kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <20110823220056.GK3895@n2100.arm.linux.org.uk> <20110825130907.GO3286@htj.dyndns.org> <20110825145558.GF8883@n2100.arm.linux.org.uk>
In-Reply-To: <20110825145558.GF8883@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108261644.26329.arnd@arndb.de>
X-Provags-ID: V02:K0:aIePoYez8zlxZPOlwy08pVs7HvCZdmfMyTf3Qwg+yX/
 zycejtZAzwufSngXnsIVH5cmmQ3RHyQ7DLWR/2GKeh3bgcVTgS
 cJefJu/LG8OU/OmhHbriCJNRma3OujYrQrHkH6yjdzs6RWcijb
 h7RJRnIOL4CJXYUN/GFq68gbq4TJ0Ja7ZNwG65LeMbIqpiHQvK
 9VqjqBXaFv3RZZ8XEcHEQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 August 2011, Russell King - ARM Linux wrote:
> 
> Arnd, can you test this to make sure your gdb test case still works, and
> Mark, can you test this to make sure it fixes your problem please?

Hi Russell,

The patch in question was not actually from me but from Ulrich Weigand,
so he's probably the right person to test your patch.
I'm forwarding it in full to Uli for reference.

	Arnd
