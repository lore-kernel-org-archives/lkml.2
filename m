Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab1CILJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 06:09:20 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40012 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab1CILJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 06:09:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=TUVlS3/jQtn+4Jxs7oLrTANi8b6xiNxPZpFaOM0PjFiCL9DpYv6RJvVGSGfXUq5ApI
         UhYDH1ifshaar77qJqnuVoUwUsGaSBYTDjbhBZul1qcmunrrb12nzMq+/FTm4PvxGkGc
         mwpRgdbQn7KnOaZXr9B9FtiF+O1vaFQacz9q4=
Date: Wed, 9 Mar 2011 14:08:05 +0300
From: Dan Carpenter <error27@gmail.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: Re: [PATCH 06/15] staging: xgifb: delete bIntegratedMMEnabled
Message-ID: <20110309110805.GE3416@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Aaro Koskinen <aaro.koskinen@iki.fi>, gregkh@suse.de,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	arnaud.patard@rtp-net.org
References: <1299615380-22922-1-git-send-email-aaro.koskinen@iki.fi>
 <1299615380-22922-7-git-send-email-aaro.koskinen@iki.fi>
 <20110308223620.GD3416@bicker>
 <alpine.DEB.1.10.1103091014430.12072@loser>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.1103091014430.12072@loser>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 10:23:01AM +0200, Aaro Koskinen wrote:
> Hi,
> 
> On Wed, 9 Mar 2011, Dan Carpenter wrote:
> >On Tue, Mar 08, 2011 at 10:16:11PM +0200, Aaro Koskinen wrote:
> >>bIntegratedMMEnabled is always true, so the field and checks can be
> >>eliminated.
> >>
> >What about for the chips that came before the XG40?  Are we dropping
> >support for them?
> 
> They were never supported. See the earlier switch (xgi_video_info.chip_id)
> statement in the probe routine - it will return -ENODEV for other chips
> than XG40..XG27.
> 

Ah...  That's true.  This patch is fine by me then.

Reviewed-by: Dan Carpenter <error27@gmail.com>

regards,
dan carpenter
