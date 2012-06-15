Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab2FOA1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:27:52 -0400
Received: from londo.lunn.ch ([80.238.139.98]:35421 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721Ab2FOA1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 20:27:51 -0400
Date: Fri, 15 Jun 2012 02:27:38 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Andrew Lunn <andrew@lunn.ch>,
        swarren@nvidia.com, linux-kernel@vger.kernel.org,
        haojian.zhuang@gmail.com, linux-arm-kernel@lists.infradead.org,
        jic23@cam.ac.uk, kay@vrfy.org
Subject: Re: Follow-up to remaining issue with alignment of __log_buf in
 printk.c
Message-ID: <20120615002738.GH26034@lunn.ch>
Mail-Followup-To: Robert Jarzmik <robert.jarzmik@free.fr>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Andrew Lunn <andrew@lunn.ch>, swarren@nvidia.com,
	linux-kernel@vger.kernel.org, haojian.zhuang@gmail.com,
	linux-arm-kernel@lists.infradead.org, jic23@cam.ac.uk, kay@vrfy.org
References: <87aa05vgzg.fsf@free.fr>
 <4FDA3BB4.9040607@wwwdotorg.org>
 <87y5np1qks.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y5np1qks.fsf@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> PS: For Andrew, I saw your patch. It won't solve my problem as my compiler
> believes __alignof__(struct log) == 4 ... bad luck for me.
> 
> PPS: My toolchain is arm-2011.09

Hi Robert

I have gcc version 4.4.5 (Debian 4.4.5-8), both native and cross.

  Andrew
