Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab2KWPb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 10:31:26 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:64358 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751711Ab2KWPbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 10:31:25 -0500
Message-ID: <1353684679.1420.7.camel@x61.thuisdomein>
Subject: Re: nouveau driver fails to build
From: Paul Bolle <pebolle@tiscali.nl>
To: Helmut Jarausch <jarausch@igpm.rwth-aachen.de>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 23 Nov 2012 16:31:19 +0100
In-Reply-To: <1353681769.29421.0@numa-i>
References: <1353681769.29421.0@numa-i>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Nov 2012 15:31:20.0449 (UTC) FILETIME=[96679710:01CDC98F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-23 at 15:42 +0100, Helmut Jarausch wrote:
> with 3.7_rc6 and
> 
> CONFIG_ACPI_VIDEO=m
> CONFIG_DRM=y
> CONFIG_DRM_KMS_HELPER=y
> CONFIG_DRM_TTM=y
> CONFIG_DRM_NOUVEAU=y
> CONFIG_NOUVEAU_DEBUG=5
> CONFIG_NOUVEAU_DEBUG_DEFAULT=3
> CONFIG_DRM_NOUVEAU_BACKLIGHT=y
> 
> with/ without
> CONFIG_DRM_LOAD_EDID_FIRMWARE=y
> 
> 
> The kernel fails to build with
> drivers/built-in.o: In function `nouveau_acpi_edid':
> (.text+0x12bf21): undefined reference to `acpi_video_get_edid'
> 
> 
> What am I missing?

I'd guess it should build (at least without this error) with
CONFIG_ACPI_VIDEO=y. Is that correct?


Paul Bolle

