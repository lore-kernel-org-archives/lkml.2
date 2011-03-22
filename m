Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab1CVSjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 14:39:37 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50612 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab1CVSjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 14:39:33 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6293"; a="81422100"
Message-ID: <4D88ECE3.1070209@codeaurora.org>
Date: Tue, 22 Mar 2011 11:39:31 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
CC: "'Arnd Bergmann'" <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Use asm-generic/sizes.h
References: <1300751462-1494-1-git-send-email-sboyd@codeaurora.org> <201103220934.50435.arnd@arndb.de> <20110322092113.GB17264@n2100.arm.linux.org.uk> <201103221110.20861.arnd@arndb.de> <00ec01cbe897$2eed7210$8cc85630$@mprc.pku.edu.cn>
In-Reply-To: <00ec01cbe897$2eed7210$8cc85630$@mprc.pku.edu.cn>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2011 06:43 AM, Guan Xuetao wrote:
> And I just complete the SZ_* definitions for 32-bit architecture,
> and remove SZ_48M for not being power-of-2 size.

Ah, I didn't notice this part. SZ_48M is actually used by ARM code so
that would need to be added to the generic header should we go with this
patch.
