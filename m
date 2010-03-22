Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab0CVIco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 04:32:44 -0400
Received: from smtprelay04.ispgateway.de ([80.67.31.38]:46295 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab0CVIcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 04:32:42 -0400
Message-ID: <4BA72B25.1050705@ladisch.de>
Date: Mon, 22 Mar 2010 09:32:37 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Frank Schaefer <fschaefer.oss@googlemail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] x86: add HPET-quirk for nVidia MCP61 LPC Bridge
 (10de:03e0)
References: <4BA3963D.5000001@googlemail.com> <4BA3A517.4010307@ladisch.de> <4BA4C52D.6020607@googlemail.com>
In-Reply-To: <4BA4C52D.6020607@googlemail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frank Schaefer wrote:
> Clemens Ladisch schrieb:
> > arch/x86 stuff should go to <x86@kernel.org>.
> 
> The get-maintainer-script told me to send it to this list. Shouldn't it
> be updated then ?

There seems to be a bug when handling patches; try "get_maintainer.pl
-f arch/x86/kernel/quirks.c".

> Also: this list seems to be mentioned nowhere,

It's mentioned in the MAINTAINERS file.


Regards,
Clemens
