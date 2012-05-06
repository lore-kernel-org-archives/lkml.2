Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab2EFDFr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 23:05:47 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:48139 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab2EFDFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 23:05:46 -0400
Date: Sat, 5 May 2012 20:03:34 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Felipe Balbi <balbi@ti.com>, Marek Vasut <marek.vasut@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] isp1704_charger: use after free on probe error
Message-ID: <20120506030334.GD29576@lizard>
References: <20120327202212.GB9197@elgon.mountain>
 <CAMP44s3orF_pcLZ4hmiV5PqjAEF1O=iYm1piOKupVL3y9utVZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMP44s3orF_pcLZ4hmiV5PqjAEF1O=iYm1piOKupVL3y9utVZw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2012 at 12:19:16AM +0300, Felipe Contreras wrote:
> On Tue, Mar 27, 2012 at 11:22 PM, Dan Carpenter
> <dan.carpenter@oracle.com> wrote:
> > We can't use "isp" after freeing it.
> 
> Oops!
> 
> Reviewed-by: Felipe Contreras <felipe.contreras@gmail.com>

Applied, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
