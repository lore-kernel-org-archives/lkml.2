Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab2JRJB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 05:01:58 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45812 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754218Ab2JRJB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 05:01:56 -0400
Message-ID: <1350550916.3072.61.camel@joe-AO722>
Subject: Re: [PATCH v3 1/1] Input: serio - Add ARC PS/2 driver
From: Joe Perches <joe@perches.com>
To: Mischa Jonker <mischa.jonker@synopsys.com>
Cc: dmitry.torokhov@gmail.com, m.d.s.x.jonker@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        arc-linux-dev@synopsys.com
Date: Thu, 18 Oct 2012 02:01:56 -0700
In-Reply-To: <1350549367-11098-2-git-send-email-mischa.jonker@synopsys.com>
References: <1350549367-11098-1-git-send-email-mischa.jonker@synopsys.com>
	 <1350549367-11098-2-git-send-email-mischa.jonker@synopsys.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 10:36 +0200, Mischa Jonker wrote:
> This adds support for the PS/2 block that is used in various ARC FPGA
> platforms.
[]
> diff --git a/drivers/input/serio/arc_ps2.c b/drivers/input/serio/arc_ps2.c
[]
> +static void arc_ps2_check_rx(struct arc_ps2_data *arc_ps2,
> +			     struct arc_ps2_port *port)
> +{
> +	unsigned flag, status;
> +	unsigned char data;
> +
> +	while (1) {

infinite loop with bad hardware?
Perhaps a jiffies timeout?


