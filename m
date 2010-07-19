Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760552Ab0GSK5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 06:57:00 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:34198 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760539Ab0GSK46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 06:56:58 -0400
Date: Mon, 19 Jul 2010 12:56:47 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Wan ZongShun <mcuos.com@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-i2c@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH v2] i2c/nuc900: add i2c driver support for nuc900
Message-ID: <20100719125647.7eecfcb9@hyperion.delvare>
In-Reply-To: <AANLkTimwIomoGV1M-0fxpSqB5UUraCsqLJGzA5Pn8lTv@mail.gmail.com>
References: <4C2441EB.8090609@gmail.com>
	<AANLkTinlGTebx8zNc_AGni_5pkTEnNf-lrVebd3YcdGk@mail.gmail.com>
	<AANLkTimwIomoGV1M-0fxpSqB5UUraCsqLJGzA5Pn8lTv@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jul 2010 11:24:21 +0800, Wan ZongShun wrote:
> How about this patch?
> Which tree can merge it?

Driver for embedded system -> Ben Dooks.

-- 
Jean Delvare
