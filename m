Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab1AOQyR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 11:54:17 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44005 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab1AOQyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 11:54:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=uNeOfiYW4fADlPNuAFWejeL1rxc7Vo+tEHJb9j7VxZZb4AzuftMumzqZJfL0sJPd16
         sKiYmmj0SS4QOXv4JcZ4Yr2BCg7C3WhgxUNGoNXjxzR5v+A3yl/+j853xCjZgWRK4w4Z
         OsUYzZ3EqeK/oUaq9VgweWr0LdlgInt0eqQnY=
Date: Sat, 15 Jan 2011 19:54:01 +0300
From: Dan Carpenter <error27@gmail.com>
To: walter harms <wharms@bfs.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        James Bottomley <James.Bottomley@suse.de>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] [SCSI] target: dubious one-bit signed bitfield
Message-ID: <20110115165401.GE2721@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	walter harms <wharms@bfs.de>,
	"Nicholas A. Bellinger" <nab@linux-iscsi.org>,
	James Bottomley <James.Bottomley@suse.de>,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <20110115140445.GD2721@bicker>
 <4D31CCFB.1060504@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D31CCFB.1060504@bfs.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 15, 2011 at 05:36:11PM +0100, walter harms wrote:
> 
> 
> Am 15.01.2011 15:04, schrieb Dan Carpenter:
> > The signed one-bit types can be 0 or -1 which can cause a problem if
> > someone ever checks if (foo->lu_gp_assoc == 1).  The current code is
> > fine because everyone just checks zero vs non-zero.  But Sparse
> > complains about it so lets change it.  The warnings look like this:
> > 
> 
> Your code looks ok,
> but to avoid that kind of errors it may be better to use int here.
> 

I'm afraid I don't understand what you are saying.

regards,
dan carpenter
