Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab1G0LJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 07:09:34 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38403 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab1G0LJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 07:09:32 -0400
MIME-Version: 1.0
In-Reply-To: <1311764347-5520-1-git-send-email-apw@canonical.com>
References: <1311764347-5520-1-git-send-email-apw@canonical.com>
Date: Wed, 27 Jul 2011 12:09:31 +0100
X-Google-Sender-Auth: WfmRMkYUoa-ly6wNAHfLBhNP6aM
Message-ID: <CAAq6er2yk6XHUwvBc+4=pTXDCWwj6cqw57nHZd0z__a+OmU8iA@mail.gmail.com>
Subject: Re: [PATCH 1/1] btrfs: btrfs_calc_avail_data_space cope with no
 read/write devices
From: Andy Whitcroft <apw@canonical.com>
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bah, this one leaked out with the wrong bug number attached.  I have
resent it with correct attribution.

On Wed, Jul 27, 2011 at 11:59 AM, Andy Whitcroft <apw@canonical.com> wrote:

> BugLink: http://bugs.launchpad.net/bugs/803815
> Signed-off-by: Andy Whitcroft <apw@canonical.com>

-apw
