Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab2LCJdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 04:33:23 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:57647 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab2LCJdW (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Mon, 3 Dec 2012 04:33:22 -0500
X-Greylist: delayed 1215 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Dec 2012 04:33:22 EST
Date: Mon, 3 Dec 2012 17:12:42 +0800
From: Guangliang Zhao <gzhao@suse.com>
To: device-mapper development <dm-devel@redhat.com>,
        linux-kernel@vger.kernel.org
Cc: Lars Marowsky-Bree <lmb@suse.com>
Subject: Re: [dm-devel] [PATCH 2/3] dm raid1: add interface to set resync
 speed
Message-ID: <20121203091242.GA2314@glzhao-laptop.site>
Mail-Followup-To: device-mapper development <dm-devel@redhat.com>,
	linux-kernel@vger.kernel.org, Lars Marowsky-Bree <lmb@suse.com>
References: <1353565673-4233-1-git-send-email-gzhao@suse.com>
 <1353565673-4233-3-git-send-email-gzhao@suse.com>
 <20121130113928.GO29064@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121130113928.GO29064@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 12:39:28PM +0100, Lars Marowsky-Bree wrote:
> On 2012-11-22T14:27:52, Guangliang Zhao <gzhao@suse.com> wrote:
> 
> Hi Guangliang,
> 
> thanks for adding this. I think this approach is a good direction to
> take, just one feedback:
> 
> > Add ioctl to control resync speed, userspace tool
> > is dmsetup message, message format is:
> > 	dmsetup message $device 0 "set $speed"
> > e.g.
> > 	dmsetup message /dev/dm-2 "set 12345"
> 
> I think this should be "set-max-resync-rate" or something; "set" is very
> generic and not very extensible going forward, should the need arise.
That's would be more clear, thanks.

> 
> Regards,
>     Lars
> 
> -- 
> Architect Storage/HA
> SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 21284 (AG Nürnberg)
> "Experience is the name everyone gives to their mistakes." -- Oscar Wilde
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

-- 
Best regards,
Guangliang
