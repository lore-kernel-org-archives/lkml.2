Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184Ab1LNNRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 08:17:01 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54684 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757140Ab1LNNQ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 08:16:59 -0500
MIME-Version: 1.0
In-Reply-To: <1323865676.32031.24.camel@dhruva>
References: <1323865676.32031.24.camel@dhruva>
Date: Wed, 14 Dec 2011 11:16:57 -0200
Message-ID: <CAOMZO5BuJbn9G2p6tZopmTGYarjmLSCTSKXAYN+aoUQjQ-mAiw@mail.gmail.com>
Subject: Re: [PATCH 05/06] Power: DA9052 Battery module V6
From: Fabio Estevam <festevam@gmail.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: cbouatmailru@gmail.com, linaro-dev@lists.linaro.org, sameo@linux.intel.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Dajun <dajun.chen@diasemi.com>,
        dwmw2@infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 10:27 AM, Ashish Jangam
<ashish.jangam@kpitcummins.com> wrote:

> +static u32 const vc_tbl[3][68][2] = {
> +       /* For temperature 10 degree celisus*/

s/celisus/Celsius

Same on other places.

Regards,

Fabio Estevam
