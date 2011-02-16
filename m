Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab1BPWOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:14:34 -0500
Received: from juliet.he.net ([184.105.210.2]:33211 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752039Ab1BPWOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:14:32 -0500
Date: Wed, 16 Feb 2011 14:14:29 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: "jgq516@gmail.com" <jgq516@gmail.com>,
        "airlied@redhat.com" <airlied@redhat.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] drm: fix wrong usages of drm_device in DRM
 Developer's Guide
Message-Id: <20110216141429.44668924.rdunlap@xenotime.net>
In-Reply-To: <20110216121859.31ab0e57@jbarnes-desktop>
References: <1297677503-11175-1-git-send-email-jgq516@gmail.com>
	<20110216121859.31ab0e57@jbarnes-desktop>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Feb 2011 12:18:59 -0800 Jesse Barnes wrote:

> On Mon, 14 Feb 2011 01:58:23 -0800
> "jgq516@gmail.com" <jgq516@gmail.com> wrote:
> 
> > From: Xiao Jiang <jgq516@gmail.com>
> > 
> > A few wrong usages of drm_device, which should be drm_driver.
> > 
> 
> Ah thanks, yeah it's mixed up.
> 
> Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>


Thanks, added to my docs quilt queue (unless someone else grabs it :).

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
