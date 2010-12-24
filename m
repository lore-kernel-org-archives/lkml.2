Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab0LXPCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 10:02:43 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32971 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab0LXPCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 10:02:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Us773MChOM74/I9BkpIAaCEk758igIODIB7G5ixRTBmVkxWP15T79Z1gHSJRg5oIci
         5X2lXgdlRt9r6HYHPal2P/BRSvnjCRK5Ba6y8Iip9f38H/hmh6LwtthxrrkhLooIRebJ
         MHaMky1bH/IxDU3SC3jSD1iZ5jtBmIlj5R1I0=
Date: Fri, 24 Dec 2010 16:02:36 +0100
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>, Roland Dreier <rolandd@cisco.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>
Subject: Re: [PATCHSET] workqueue: remove flush_scheduled_work() usage
Message-ID: <20101224150236.GB11419@htj.dyndns.org>
References: <1292086307-19211-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292086307-19211-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 11, 2010 at 05:51:17PM +0100, Tejun Heo wrote:
> Hello,
> 
> This patchset removes flush_scheduled_work() usage to prepare for
> deprecation of the interface.  Patches in this series are self
> contained and mostly straight-forward.  More complex conversions will
> be done in separate patchsets.
> 
> This patchset contains the following 30 patches.
> 
>  0001-infiniband-update-workqueue-usage.patch
>  0002-isdn-capi-unregister-capictr-notifier-after-init-fai.patch
>  0003-isdn-capi-make-kcapi-use-a-separate-workqueue.patch
>  0004-drm-ttm-use-cancel_delayed_work_sync-in-ttm_bo.patch
>  0005-net-dsa-don-t-use-flush_scheduled_work.patch
>  0006-ncpfs-don-t-use-flush_scheduled_work.patch
>  0007-ocfs2-don-t-use-flush_scheduled_work.patch
>  0008-afs-add-afs_wq-and-use-it-instead-of-the-system-work.patch
>  0009-sound-don-t-use-flush_scheduled_work.patch
>  0010-arm-sharpsl-don-t-use-flush_scheduled_work.patch
>  0011-sh-don-t-use-flush_scheduled_work.patch
>  0012-floppy-don-t-use-flush_scheduled_work.patch
>  0013-gdrom-don-t-use-flush_scheduled_work.patch
>  0014-xen-don-t-use-flush_scheduled_work.patch
>  0015-hvsi-don-t-use-flush_scheduled_work.patch
>  0016-sonypi-don-t-use-flush_scheduled_work.patch
>  0017-tpm-don-t-use-flush_scheduled_work.patch
>  0018-vmwgfx-don-t-use-flush_scheduled_work.patch
>  0019-hid-picolcd-don-t-use-flush_scheduled_work.patch
>  0020-macintosh-ams-don-t-use-flush_scheduled_work.patch
>  0021-pcmcia-ipwireless-don-t-use-flush_scheduled_work.patch
>  0022-mISDN-don-t-use-flush_scheduled_work.patch
>  0023-leds-wm8350-don-t-use-flush_scheduled_work.patch
>  0024-dvb-don-t-use-flush_scheduled_work.patch
>  0025-mfd-update-workqueue-usages.patch
>  0026-mmc-update-workqueue-usages.patch
>  0027-mtd-don-t-use-flush_scheduled_work.patch
>  0028-battery-don-t-use-flush_scheduled_work.patch
>  0029-rtc-don-t-use-flush_scheduled_work.patch
>  0030-s390-don-t-use-flush_scheduled_work.patch

Patches other than 0001 and 0008 are merged into wq#for-next.

Thanks.

-- 
tejun
