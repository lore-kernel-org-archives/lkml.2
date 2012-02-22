Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab2BVJu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 04:50:57 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48860 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab2BVJuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 04:50:55 -0500
Date: Wed, 22 Feb 2012 09:50:40 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, rmallon@gmail.com
Subject: Re: [PATCH v2 06/19] ARM: at91/pm_slowclock: rename register to
	named define
Message-ID: <20120222095040.GU22562@n2100.arm.linux.org.uk>
References: <0d78171672a30e8ec8084f54a557e9948260356d.1329903206.git.nicolas.ferre@atmel.com> <cce50d2859ae080d6bfd9260fcd6932d634f7b9a.1329903206.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cce50d2859ae080d6bfd9260fcd6932d634f7b9a.1329903206.git.nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 10:39:32AM +0100, Nicolas Ferre wrote:
>  #define PLLALOCK_TIMEOUT	1000
>  #define PLLBLOCK_TIMEOUT	1000
>  
> +#define pmc	r1

pmc	.req	r1
sdramc	.req	r2

etc.
