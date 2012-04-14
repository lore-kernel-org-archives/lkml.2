Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329Ab2DNVTU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 17:19:20 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47885 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756282Ab2DNVTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 17:19:18 -0400
MIME-Version: 1.0
In-Reply-To: <20120327202212.GB9197@elgon.mountain>
References: <20120327202212.GB9197@elgon.mountain>
Date: Sun, 15 Apr 2012 00:19:16 +0300
Message-ID: <CAMP44s3orF_pcLZ4hmiV5PqjAEF1O=iYm1piOKupVL3y9utVZw@mail.gmail.com>
Subject: Re: [patch] isp1704_charger: use after free on probe error
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Felipe Balbi <balbi@ti.com>, Marek Vasut <marek.vasut@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 11:22 PM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> We can't use "isp" after freeing it.

Oops!

Reviewed-by: Felipe Contreras <felipe.contreras@gmail.com>

-- 
Felipe Contreras
