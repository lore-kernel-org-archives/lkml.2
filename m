Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab0CSQYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 12:24:01 -0400
Received: from smtprelay04.ispgateway.de ([80.67.31.31]:56579 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab0CSQX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 12:23:58 -0400
Message-ID: <4BA3A517.4010307@ladisch.de>
Date: Fri, 19 Mar 2010 17:23:51 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Frank Schaefer <fschaefer.oss@googlemail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] x86: add HPET-quirk for nVidia MCP61 LPC Bridge
 (10de:03e0)
References: <4BA3963D.5000001@googlemail.com>
In-Reply-To: <4BA3963D.5000001@googlemail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frank Schaefer wrote:
> Any comments on this patch ?

Gmail ate your tabs; see Documentation/email-clients.txt.

Cosmetic changes to not belong in the stable tree; see
Documentation/stable_kernel_rules.txt.

> Wrong list ?

arch/x86 stuff should go to <x86@kernel.org>.


Regards,
Clemens
