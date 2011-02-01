Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab1BANFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:05:18 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:32825 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab1BANFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:05:17 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: ucb1400_gpio driver Kconfig entry
Date: Tue, 01 Feb 2011 14:05:13 +0100
Message-ID: <87bp2vsy5y.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

drivers/gpio/Kconfig says:

config GPIO_UCB1400
        bool "Philips UCB1400 GPIO"
        depends on UCB1400_CORE
        help
          This enables support for the Philips UCB1400 GPIO pins.
          The UCB1400 is an AC97 audio codec.

          To compile this driver as a module, choose M here: the
          module will be called ucb1400_gpio.

But you use bool above, so choosing M isn't actually an option.
Maybe you want to resolve this inconsistency.
-- 
Regards,
Feri.
