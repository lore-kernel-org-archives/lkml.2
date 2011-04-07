Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab1DGKf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 06:35:27 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:47098 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab1DGKf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 06:35:26 -0400
Subject: Re: [PATCH] ARM: Allow for kernel command line concatenation
From: Paul Bolle <pebolle@tiscali.nl>
To: oskar.andero@sonyericsson.com
Cc: linux@arm.linux.org.uk, nicolas.pitre@linaro.org, will.deacon@arm.com,
        eric.y.miao@gmail.com, catalin.marinas@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Victor Boivie <victor.boivie@sonyericsson.com>
Date: Thu, 07 Apr 2011 12:35:01 +0200
In-Reply-To: <1302164236-1516-1-git-send-email-oskar.andero@sonyericsson.com>
References: <1302164236-1516-1-git-send-email-oskar.andero@sonyericsson.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.92 (2.91.92-1.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1302172525.24493.7.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-07 at 10:17 +0200, oskar.andero@sonyericsson.com wrote:
> +config CMDLINE_EXTEND
> +	bool "Extend bootloader kernel arguments"
> +	depends on CMDLINE != ""
> +	help
> +	  The default kernel command string will be concatenated with the
> +	  arguments provided by the boot loader.

This suggests the parameters provided by the boot loader will override
corresponding parameters of the default kernel command string. Is that
correct (for all possible parameters)?

Either way, shouldn't it be documented, perhaps in this help text, what
will happen if a parameter of the default kernel command string and a
parameter provided by the boot loader somehow conflict?


Paul Bolle

