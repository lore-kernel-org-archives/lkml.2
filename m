Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551Ab2EVLkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 07:40:33 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46168 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757811Ab2EVLkc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 07:40:32 -0400
MIME-Version: 1.0
In-Reply-To: <20120522092552.GB21999@opensource.wolfsonmicro.com>
References: <CAOMZO5A-05jTYpEEPfnJvWpby1YJ1M7=KPn=zahbQrQOgbjR4g@mail.gmail.com>
	<201205221053.21792.marc@cpdesign.com.au>
	<20120522092552.GB21999@opensource.wolfsonmicro.com>
Date: Tue, 22 May 2012 08:40:30 -0300
Message-ID: <CAOMZO5DJUXna-zn98Zs0exin+THQhB3SG9To5N-QEEcDYrmXRA@mail.gmail.com>
Subject: Re: mc13xxx-core: kernel hangs after 'regmap_read'
From: Fabio Estevam <festevam@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Marc Reilly <marc@cpdesign.com.au>, Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        =?UTF-8?Q?Philippe_R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philippe,

On Tue, May 22, 2012 at 6:25 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> It's only this chip that's doing so.  I'd suggest putting a scope on it
> and having a look at the formatted data.

Does mx31-moboard allow you to put the scope on the SPI lines
connected to the mc13783?

On mx31pdk board these lines are connected directly from the mx31 to
mc13783 without any test points for easy access.
