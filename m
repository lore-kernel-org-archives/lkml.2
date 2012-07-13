Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab2GMNmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 09:42:21 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65271 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757488Ab2GMNmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 09:42:17 -0400
Subject: Re: [PATCH] bnx2: update bnx2-mips-09 firmware to
 bnx2-mips-09-6.2.1b
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Chris Webb <chris@arachsys.com>
Cc: Michael Chan <mchan@broadcom.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20120713130405.GS13885@arachsys.com>
References: <20120713130405.GS13885@arachsys.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Jul 2012 15:42:12 +0200
Message-ID: <1342186932.3265.8364.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-13 at 14:04 +0100, Chris Webb wrote:
> Commit c2c20ef43d00 "bnx2: Update driver to use new mips firmware"
> updated the bnx2 driver to use bnx2-mips-09-6.2.1b in place of
> bnx2-mips-09-6.2.1a, but didn't replace the copy of bnx2-mips-09-6.2.1a
> in firmware/bnx2/ with the new version.
> 
> This means that the bnx2 driver stopped working altogether for users who
> use CONFIG_FIRMWARE_IN_KERNEL to compile firmware together with drivers
> into their kernel, rather than having a runtime firmware loader.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Chris Webb <chris@arachsys.com>
> ---

Have you read firmware/README.AddingFirmware ?



