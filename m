Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab2DWRRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 13:17:25 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40848 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab2DWRRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 13:17:23 -0400
Message-ID: <4F958E9F.8070402@wwwdotorg.org>
Date: Mon, 23 Apr 2012 11:17:19 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, jic23@cam.ac.uk, gregkh@linuxfoundation.org,
        swarren@nvidia.com, olof@lixom.net,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH V2 2/4] staging: iio: light: of: Fix vendor prefix of
 isl29018/isl29028
References: <1335183097-21104-1-git-send-email-ldewangan@nvidia.com> <1335183097-21104-4-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1335183097-21104-4-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 06:11 AM, Laxman Dewangan wrote:
> ISL29018/ISL29028 is from Intersil Corporation and making the
> vendor prefix for this part as "isil" for OF compatibity.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

I assume this patch will go through the staging tree. Let me know if you
want me to take it through the Tegra tree.
