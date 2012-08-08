Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab2HHGDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 02:03:37 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13227 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528Ab2HHGDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 02:03:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 07 Aug 2012 22:58:26 -0700
Message-ID: <5021FF92.8030904@nvidia.com>
Date: Wed, 8 Aug 2012 11:26:34 +0530
From: Venu Byravarasu <vbyravarasu@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: question on devm_kfree
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per comments related to devm_kzalloc, memory allocated using it is freed automatically.
However there is a function called devm_kfree, comment section of which says that it is used to free memory allocated using devm_kzalloc().
If memory allocated by devm_kzalloc is freed automatically, what's the need & significance of devm_kfree?

Thanks,
Venu

