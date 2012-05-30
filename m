Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab2E3AxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 20:53:25 -0400
Received: from plane.gmane.org ([80.91.229.3]:37029 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754287Ab2E3AxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 20:53:24 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: walt <w41ter@gmail.com>
Subject: Re: [PATCH v2] scsi: fix async probe regression
Date: Tue, 29 May 2012 17:53:02 -0700
Message-ID: <jq3r1h$p37$1@dough.gmane.org>
References: <20120525175140.22423.21697.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: adsl-69-234-185-244.dsl.irvnca.pacbell.net
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120420 Thunderbird/12.0
In-Reply-To: <20120525175140.22423.21697.stgit@dwillia2-linux.jf.intel.com>
Cc: linux-scsi@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2012 10:55 AM, Dan Williams wrote:
> Commit a7a20d1 "[SCSI] sd: limit the scope of the async probe domain"
> moved sd probe work out of reach of wait_for_device_probe().  Allow it
> to be synced via scsi_complete_async_scans().

Hi Dan.  After applying version 2 of a7a20d1 I can boot again, but there's
a catch :)

My grub.cfg boot menu entry uses the root=PARTUUID=<guid> syntax, but that
has stopped working.  After a7a20d1(v2) I have to use root=/dev/sda5 or I
get the familiar "can't find block device (foo,bar)" kernel panic.

Any idea what would cause that particular kind of breakage?

Thanks!

