Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab0ISPNT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 11:13:19 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63889 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab0ISPNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 11:13:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=Y/5wDYZCdWJoQYuI+Q0oFbgh9/3rBnERkbjVmn5G8U6wKQTToJAYzcYLN7TIfYtdri
         sB5rZesXb9LPrdTSd9HPT5Z+S/wF53djaSmaUTVCZnebch++Yximlrq4r+eUKQS0fRNN
         Q8AgowHxd/C1718BWLLXGvsxgUmUQE0Xts2Ck=
Date: Sun, 19 Sep 2010 17:12:58 +0200
From: Dan Carpenter <error27@gmail.com>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>,
        Benny Halevy <bhalevy@panasas.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        osd-dev@open-osd.org, linux-scsi@vger.kernel.org,
        cornelia.huck@de.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/14] scsi: osd: fix device_register() error handling
Message-ID: <20100919151258.GG6236@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Vasiliy Kulikov <segooon@gmail.com>,
	kernel-janitors@vger.kernel.org,
	Boaz Harrosh <bharrosh@panasas.com>,
	Benny Halevy <bhalevy@panasas.com>,
	"James E.J. Bottomley" <James.Bottomley@suse.de>,
	Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	osd-dev@open-osd.org, linux-scsi@vger.kernel.org,
	cornelia.huck@de.ibm.com, linux-kernel@vger.kernel.org
References: <1284900907-24621-1-git-send-email-segooon@gmail.com> <20100919142653.GF6236@bicker> <20100919143948.GA4866@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100919143948.GA4866@albatros>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 19, 2010 at 06:39:50PM +0400, Vasiliy Kulikov wrote:
> > 
> > If that's the case then the put_device() should be called infront of the
> > goto.
> 
> As it is the last call that may fail, it is redundant.  Or you mean for future,
> if someone adds more code after device_register()?
> 

Yes.  I mean in the future.

regards,
dan carpenter

>  
> Thanks,
> -- 
> Vasiliy
