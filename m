Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364Ab0E0Qxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 12:53:41 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50660 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932291Ab0E0Qxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 12:53:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=rTDt4YuZbeSI3YOdK9WHZvzyMfUEqm/yAyPMH8ylcJs2C2eeZH3E/ADt9CTkn40AD4
         rp98c3LI0ABCm7DNga090wS3aveXjpu/rHfSJP0/XLJjBKV13DN9X5AA1iU5ELNPVSHv
         QCqgqSb5Bz3Q0j7f6qdjPcX/oHbLICzYSWU6k=
Date: Thu, 27 May 2010 18:53:02 +0200
From: Dan Carpenter <error27@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: HighPoint Linux Team <linux@highpoint-tech.com>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 7/11] drivers/scsi: Eliminate a NULL pointer dereference
Message-ID: <20100527165301.GU22515@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Julia Lawall <julia@diku.dk>,
	HighPoint Linux Team <linux@highpoint-tech.com>,
	"James E.J. Bottomley" <James.Bottomley@suse.de>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.1005271433330.5422@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1005271433330.5422@ask.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 02:33:47PM +0200, Julia Lawall wrote:
> If it is a problem to use 0 when host is NULL, then the code could be fixed
> in another way.
> 

Yeah.  It seems like it would be better to give a clearly bogus number.
I would have said -1 but "scsi-1" looks normal so maybe something like 
9999999?

regards,
dan carpenter
