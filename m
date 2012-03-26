Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738Ab2CZOqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 10:46:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51984 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932489Ab2CZOqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 10:46:37 -0400
Message-ID: <4F70812A.4080205@zytor.com>
Date: Mon, 26 Mar 2012 07:46:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: eric.piel@tremplin-utc.net, vojcek@tlen.pl, dsdt@gaugusch.at,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, Lin Ming <ming.m.lin@intel.com>, lenb@kernel.org,
        robert.moore@intel.com, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] ACPI: Implement overriding of arbitrary ACPI tables via
 initrd
References: <1332512984-79664-1-git-send-email-trenn@suse.de> <201203260245.43177.trenn@suse.de> <4F6FC57D.3050404@zytor.com> <201203261619.31766.trenn@suse.de>
In-Reply-To: <201203261619.31766.trenn@suse.de>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2012 07:19 AM, Thomas Renninger wrote:
> Do the names have to be fixed?

No, I assume it would "all files inside this namespace".

> If there is only one file where all ACPI table binaries are glued
> together kernel/acpi_tables.binary.blob
> my code should already work as good as unmodified.
> 
> Not sure what is best and whether anybody cares about how the tables
> are layed out.
> 
> I guess I just wait until your functionality is in linux-next and
> give it a closer look then and may come up with a new patch.

I doubt it will get into linux-next without a user.  If you have time to
pull in the code I sent it will be quicker, otherwise I'll probably
setup a git tree upon which things can be put.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

