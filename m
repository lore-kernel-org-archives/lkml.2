Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027Ab1CRPbN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 11:31:13 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63085 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756929Ab1CRPa6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 11:30:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=L6alfZbuXECb+z9ydLnNhYobAvJuQSL3fZNDIO5U3SaMH76o7pdkHQOlPM9PKjOkYJ
         GD9xKvkXlhp282rG4fwmevqHUZk4BtzOMq1v0rINMwrlYDkHblkyhPlWNXU1nrpSLoyb
         u+kKxVkDjVBR7XgtfSxIgnA4NuvmFG8CazmeQ=
MIME-Version: 1.0
In-Reply-To: <1300461684-21775-2-git-send-email-Dinh.Nguyen@freescale.com>
References: <1300461684-21775-1-git-send-email-Dinh.Nguyen@freescale.com>
	<1300461684-21775-2-git-send-email-Dinh.Nguyen@freescale.com>
Date: Fri, 18 Mar 2011 12:30:55 -0300
Message-ID: <AANLkTimg6uc9cq53e54BqLsRzPXH1DNBF9cThHavdJs=@mail.gmail.com>
Subject: Re: [PATCHv4 2/3] ARM: mx51: Implement code to allow mx51 to enter WFI
From: Fabio Estevam <festevam@gmail.com>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, s.hauer@pengutronix.de,
        u.kleine-koenig@pengutronix.de, arnaud.patard@rtp-net.org,
        ra5478@freescale.com, xiao-lizhang@freescale.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dinh,

On Fri, Mar 18, 2011 at 12:21 PM,  <Dinh.Nguyen@freescale.com> wrote:
...
> +       /* Enable NEON SRPG for all but MX50TO1.0. */
> +       if (cpu_is_mx51() || cpu_is_mx53())
> +               __raw_writel(arm_srpgcr, MXC_SRPG_NEON_SRPGCR);

The comment says that NEON SRPG should not be enabled for MX50 TO1.0,
but your code does not check the MX50 silicon revision.

Regards,

Fabio Estevam
