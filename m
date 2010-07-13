Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab0GMSll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 14:41:41 -0400
Received: from avexcashub1.qlogic.com ([198.70.193.61]:43141 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab0GMSlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 14:41:39 -0400
Subject: Re: [PATCH 09/36] drivers/infiniband: Remove unnecessary casts of
 private_data
From: Ralph Campbell <ralph.campbell@qlogic.com>
To: Joe Perches <joe@perches.com>
CC: Jiri Kosina <trivial@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Infinipath <Infinipath@qlogic.com>, Roland Dreier <rolandd@cisco.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
In-Reply-To: <0074ff36bc27b141d3639e2d516cc6cd48364df6.1278967120.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
	 <0074ff36bc27b141d3639e2d516cc6cd48364df6.1278967120.git.joe@perches.com>
Content-Type: text/plain; charset="us-ascii"
Organization: QLogic
Date: Tue, 13 Jul 2010 11:41:37 -0700
Message-ID: <1279046497.2296.170.camel@chromite.mv.qlogic.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Ralph Campbell <ralph.campbell@qlogic.com>

On Mon, 2010-07-12 at 13:50 -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/infiniband/hw/ipath/ipath_file_ops.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/ipath/ipath_file_ops.c b/drivers/infiniband/hw/ipath/ipath_file_ops.c
> index 9c5c66d..65eb892 100644
> --- a/drivers/infiniband/hw/ipath/ipath_file_ops.c
> +++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c
> @@ -2055,7 +2055,7 @@ static int ipath_close(struct inode *in, struct file *fp)
>  
>  	mutex_lock(&ipath_mutex);
>  
> -	fd = (struct ipath_filedata *) fp->private_data;
> +	fd = fp->private_data;
>  	fp->private_data = NULL;
>  	pd = fd->pd;
>  	if (!pd) {


