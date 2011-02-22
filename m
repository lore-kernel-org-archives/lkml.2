Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab1BVUSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:18:46 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:40938 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751981Ab1BVUSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:18:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=hK59OVWDcVzedFwocn0zxIWHWE3PjnlB/PqWLJyHIh229SJn240CAJOQBtvj7Tr5HzzLzGJBrAzfLoX32eZ6mcb1XHWlYBByQiPGufYoU3SfABBB2Oc9rbHxyQUKon6F;
Date: Tue, 22 Feb 2011 12:18:40 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-acpi@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, alan@linux.intel.com
Subject: Re: [Intel-gfx] [PATCH 1/2] ACPI/Intel: Rework Opregion support
Message-ID: <20110222121840.32a6e782@jbarnes-desktop>
In-Reply-To: <1298404994-2907-1-git-send-email-mjg@redhat.com>
References: <1298404994-2907-1-git-send-email-mjg@redhat.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Feb 2011 15:03:13 -0500
Matthew Garrett <mjg@redhat.com> wrote:

> The Integrated Graphics Device opregion specification defines a mechanism
> for the OS and system firmware to collaborate on various graphics-related
> functionality. This is currently implemented in the i915 driver but isn't
> strictly limited to these devices. Move it to a more generic location and
> remove the i915 dependency, while simultaneously reworking i915 to make
> use of the new driver.

Nice, having it split out makes sense.  And I like the formalized
interface between the driver and the OpRegion features.

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
