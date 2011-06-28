Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326Ab1F1GZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 02:25:36 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52859 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab1F1GXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 02:23:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=djXX3jrthGdmqYBeI+hiPZn6inRjRWrbxxHMn0xfy4xMeL3VIXzG8M0jun8VXP5scZ
         rfsTr3YC0+Z5WdHEZxrlsSOL+Xw/JbLh0zwZbBdOAsRtTNsE7DjcKS8FxPG6aL7FAVdY
         S5iNuWJ01KNQeaAqsbXwr3+03Qt72XE1vMbco=
Date: Tue, 28 Jun 2011 09:22:35 +0300
From: Dan Carpenter <error27@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        James Bottomley <jbottomley@parallels.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][Resend] SCSI, target, loopback: Fix memory leak in
 tcm_loop_make_scsi_hba()
Message-ID: <20110628062235.GB14591@shale.localdomain>
References: <alpine.LNX.2.00.1106272351520.30245@swampdragon.chaosbits.net>
 <20110627222526.GA14591@shale.localdomain>
 <alpine.LNX.2.00.1106280029150.30245@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1106280029150.30245@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 12:30:17AM +0200, Jesper Juhl wrote:
> 
> You mean like this - right?

Yeah.

Acked-by: Dan Carpenter <error27@gmail.com>

regards,
dan carpenter

