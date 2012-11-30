Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030246Ab2K3L7I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:59:08 -0500
Received: from gate.in-addr.de ([212.8.193.158]:33812 "EHLO mx.in-addr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755982Ab2K3L6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:58:03 -0500
X-Greylist: delayed 1078 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Nov 2012 06:58:02 EST
Date: Fri, 30 Nov 2012 12:39:28 +0100
From: Lars Marowsky-Bree <lmb@suse.com>
To: device-mapper development <dm-devel@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 2/3] dm raid1: add interface to set resync
 speed
Message-ID: <20121130113928.GO29064@suse.de>
References: <1353565673-4233-1-git-send-email-gzhao@suse.com>
 <1353565673-4233-3-git-send-email-gzhao@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1353565673-4233-3-git-send-email-gzhao@suse.com>
X-Ctuhulu: HASTUR
User-Agent: Mutt/1.5.21 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-22T14:27:52, Guangliang Zhao <gzhao@suse.com> wrote:

Hi Guangliang,

thanks for adding this. I think this approach is a good direction to
take, just one feedback:

> Add ioctl to control resync speed, userspace tool
> is dmsetup message, message format is:
> 	dmsetup message $device 0 "set $speed"
> e.g.
> 	dmsetup message /dev/dm-2 "set 12345"

I think this should be "set-max-resync-rate" or something; "set" is very
generic and not very extensible going forward, should the need arise.

Regards,
    Lars

-- 
Architect Storage/HA
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 21284 (AG Nürnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde

