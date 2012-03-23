Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759830Ab2CWUGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 16:06:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56990 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757872Ab2CWUGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 16:06:19 -0400
Message-ID: <4F6CD79A.8020805@zytor.com>
Date: Fri, 23 Mar 2012 13:05:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: eric.piel@tremplin-utc.net, vojcek@tlen.pl, dsdt@gaugusch.at,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, Lin Ming <ming.m.lin@intel.com>, lenb@kernel.org,
        robert.moore@intel.com
Subject: Re: [PATCH] ACPI: Implement overriding of arbitrary ACPI tables via
 initrd
References: <1332512984-79664-1-git-send-email-trenn@suse.de>
In-Reply-To: <1332512984-79664-1-git-send-email-trenn@suse.de>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2012 07:29 AM, Thomas Renninger wrote:
> Details can be found in:
> Documentation/acpi/initrd_table_override.txt

I did not see in this any discussion about how the data format of the
initrd/initramfs gets affected.  There are some other things too
(microcode updates, for example) which also would like to get initramfs
data early, and maybe we need to think about how to containerize this
properly.

	-hpa
