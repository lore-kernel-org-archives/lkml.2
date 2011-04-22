Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541Ab1DVSDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 14:03:18 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55362 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423Ab1DVSDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 14:03:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nWhsNmT5p5V4GEK4aba+CKnvr6o6AkUe8RJPSndRf6SXssU0U7l6Xn2Emz5M2Jaid5
         YN0Pk4qYAnkYdX5wgdDCvsJJp5xw0IFjWHlSmnnwidSq8PLsd7FwP/hDRoyFyq+vwzse
         F9PlpVSAnQaAeXUJiNfXudee/xPDHuwl77Kp8=
Date: Fri, 22 Apr 2011 20:03:11 +0200
From: Tejun Heo <tj@kernel.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>
Subject: Re: Strange block/scsi/workqueue issue
Message-ID: <20110422180311.GC21902@mtj.dyndns.org>
References: <1302627097.2661.25.camel@dolmen>
 <1302630090.2604.30.camel@mulgrave.site>
 <1302633208.2661.29.camel@dolmen>
 <1302638216.2604.35.camel@mulgrave.site>
 <1302640226.2661.34.camel@dolmen>
 <1302641036.2604.40.camel@mulgrave.site>
 <20110413051846.GD24161@mtj.dyndns.org>
 <20110413060651.GA27823@mtj.dyndns.org>
 <1302686454.2613.4.camel@dolmen>
 <1302703208.2613.18.camel@dolmen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302703208.2613.18.camel@dolmen>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 03:00:08PM +0100, Steven Whitehouse wrote:
> Apologies, some gfs2 bits got included by accident. Here is a cleaned up
> version,

Great, thanks.  I'll clean it up and try to get it included for the
next merge window.

Thank you.

-- 
tejun
