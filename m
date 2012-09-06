Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932976Ab2IFSY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 14:24:28 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48435 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab2IFSY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 14:24:26 -0400
Message-ID: <5048EA57.20308@wwwdotorg.org>
Date: Thu, 06 Sep 2012 12:24:23 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: tegra: fix return value for debugfs init
References: <1346943329-4898-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1346943329-4898-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 08:55 AM, Peter De Schrijver wrote:
> tegra_powergate_debugfs_init() always returns -ENOMEM. It shouldn't do that
> when registering the debugfs entry succeeded.

Thanks, applied the series to Tegra's for-3.7/fixes branch.

