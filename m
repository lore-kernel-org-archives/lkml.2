Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311Ab1FJODp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 10:03:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64089 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab1FJODn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 10:03:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nF+tdSgepPBBVxPD0/ozlsWFku/ob0zvJ8ESL+Nn7GYjkd8U07REkdWyT62BODhuOR
         2bkQy6mI8DYLdldQETO8nTCKZf7VxP/xZ3DPh3uZU4QoLKhRwgVxg8+es/qGgVWznsw0
         Yq3LyvSdOYa6oex2ClFoiE6MKBmXgO+yRgpNc=
Date: Fri, 10 Jun 2011 16:01:55 +0200
From: Tejun Heo <htejun@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Bruce Stenning <b.stenning@indigovision.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Message-ID: <20110610140155.GJ15235@htj.dyndns.org>
References: <20110425162242.GB30828@mtj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C77554BDC@gretna.indigovision.com>
 <20110426135027.GI878@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C77554C70@gretna.indigovision.com>
 <20110426155229.GM878@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C77554C91@gretna.indigovision.com>
 <20110430140109.GJ29280@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C777089B2@gretna.indigovision.com>
 <20110525094127.GF10146@htj.dyndns.org>
 <4DF20E03.9030502@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF20E03.9030502@teksavvy.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(cc'ing Jeff)

On Fri, Jun 10, 2011 at 08:28:51AM -0400, Mark Lord wrote:
> Tejun, did this ever go upstream and to -stable ??
> I'm asking because I see the same issue with other SATA controllers,
> in particular with sata_sil boards.  Hot plug generally works _once_
> per port, and then stops working.

The patch is still pending,

 http://article.gmane.org/gmane.linux.ide/49613

I don't think it would be wise to include the patch for -stable tho.
It's not a regression fix and has some possibility of introducing
regressions, so....

Thanks.

-- 
tejun
