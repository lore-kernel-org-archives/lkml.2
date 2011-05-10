Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab1EJT5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 15:57:07 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39783 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab1EJT5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 15:57:05 -0400
Subject: Re: [PATCH] Revert "regulator: Move VCOINCELL to be the last
 element of mc13892_regulators array"
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Yong Shen <yong.shen@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1305025836.2569.2.camel@phoenix>
References: <1305025836.2569.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 20:56:59 +0100
Message-ID: <1305057419.3206.43.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-10 at 19:10 +0800, Axel Lin wrote:
> I check this patch again and found this actually is not a bug
> because MC13xxx_DEFINE explictly defines the order of each entry in the array.
> 
> Thus revert the patch.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied.

