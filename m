Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797Ab2C1MMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 08:12:34 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53539 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab2C1MMd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 08:12:33 -0400
MIME-Version: 1.0
In-Reply-To: <1332935527-21414-1-git-send-email-alexg@meprolight.com>
References: <1332935527-21414-1-git-send-email-alexg@meprolight.com>
Date: Wed, 28 Mar 2012 09:12:31 -0300
Message-ID: <CAOMZO5DE0wcdbk7xbXuOFKJ=NNtSrWTPaLjRAdDfewOmPR-eVw@mail.gmail.com>
Subject: Re: [PATCH v2] regulator: i.MX35-PDK Add regulator support
From: Fabio Estevam <festevam@gmail.com>
To: Alex Gershgorin <alexg@meprolight.com>
Cc: s.hauer@pengutronix.de, fabio.estevam@freescale.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 8:52 AM, Alex Gershgorin <alexg@meprolight.com> wrote:
> This version rebased for v3.4, also removes ranges from regulators
> who do not have consumers and adds consumers for same regulators.

In your subject: prefix it with "ARM" as this patch should go via the arm tree.

Also, do not put comments about kernel version in the commit log.
If you want to talk about kernel version/patch history you can do so
below the --- line.

...
> +static struct regulator_consumer_supply vcam_consumers[] = {
> +       /* sgtl5000 */
> +       REGULATOR_SUPPLY("VDDA", "1-000a"),

This should be "0-000a" instead.
