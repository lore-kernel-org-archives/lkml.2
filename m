Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab2IXU2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 16:28:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56724 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757981Ab2IXU2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 16:28:09 -0400
Message-ID: <5060C234.80006@zytor.com>
Date: Mon, 24 Sep 2012 13:27:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Thomas Renninger <trenn@suse.de>, initramfs@vger.kernel.org,
        robert.moore@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, yinghai@kernel.org,
        eric.piel@tremplin-utc.net, vojcek@tlen.pl,
        Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH 2/2] ACPI: Override arbitrary ACPI tables via initrd for
 debugging
References: <1348234085-39220-1-git-send-email-trenn@suse.de> <1348234085-39220-3-git-send-email-trenn@suse.de> <505DD65F.9080203@kernel.org>
In-Reply-To: <505DD65F.9080203@kernel.org>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2012 08:16 AM, Len Brown wrote:
> This isn't a NAK, but I'm at best, "like warm" on this.
> 
> I'm not convinced it is a good thing to have - enabled by default -
> the ability for users to easily over-ride ACPI tables.

For the record: I'm fine with the implementation from a technical
standpoint now; I'm completely agnostic on the policy.  Since Len is the
ACPI maintainer this is up to him.

	-hpa

