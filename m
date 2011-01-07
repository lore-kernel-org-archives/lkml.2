Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab1AGAc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 19:32:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54597 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753939Ab1AGAc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 19:32:58 -0500
Date: Thu, 6 Jan 2011 16:31:40 -0800
From: Greg KH <gregkh@suse.de>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        clemens@ladisch.de, sakari.ailus@maxwell.research.nokia.com
Subject: Re: [RFC/PATCH v7 01/12] media: Media device node support
Message-ID: <20110107003140.GA3828@suse.de>
References: <0iuif2gxlcatpj50djfn40p8.1294359457034@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0iuif2gxlcatpj50djfn40p8.1294359457034@email.android.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Thu, Jan 06, 2011 at 07:24:27PM -0500, Andy Walls wrote:
> Why, yes, there is a standard:
> 
> http://pubs.opengroup.org/onlinepubs/009695399/functions/xsh_chap02_03.html
> 
> A somewhat verbose description of the errnos is in section 2.3.

Ah, so perhaps -ENXIO is the correct thing to return with here.

thanks,

greg k-h
