Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab2EYB4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 21:56:40 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:43943 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054Ab2EYB4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 21:56:38 -0400
Date: Fri, 25 May 2012 02:56:30 +0100
From: Matthew Garrett <mjg@redhat.com>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>,
        randy.dunlap@oracle.com, gregkh@suse.de, trenn@suse.de,
        Valdis.Kletnieks@vt.edu, Dennis.Jansen@web.de, airlied@redhat.com,
        eric@anholt.net, alexdeucher@gmail.com, bskeggs@redhat.com,
        chris@chris-wilson.co.uk
Subject: Re: [PATCH] gpu: remove gma500 stub driver
Message-ID: <20120525015630.GA610@srcf.ucam.org>
References: <1337910644-21694-1-git-send-email-jlee@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337910644-21694-1-git-send-email-jlee@suse.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 09:50:44AM +0800, Lee, Chun-Yi wrote:
> In v3.3, the gma500 drm driver moved from staging to drm group by
> Alan Cox's 3abcf41fb patch. the gma500 drm driver should control
> brightness well and don't need gma500 stub driver anymore.

Looks good to me.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
