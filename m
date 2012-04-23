Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab2DWRoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 13:44:04 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46041 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923Ab2DWRn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 13:43:59 -0400
Message-ID: <4F9594DB.5070308@wwwdotorg.org>
Date: Mon, 23 Apr 2012 11:43:55 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Laxman Dewangan <ldewangan@nvidia.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rob@landley.net, linux@arm.linux.org.uk,
        jic23@cam.ac.uk, swarren@nvidia.com, olof@lixom.net,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH V2 2/4] staging: iio: light: of: Fix vendor prefix of
 isl29018/isl29028
References: <1335183097-21104-1-git-send-email-ldewangan@nvidia.com> <1335183097-21104-4-git-send-email-ldewangan@nvidia.com> <4F958E9F.8070402@wwwdotorg.org> <20120423172829.GA2666@kroah.com>
In-Reply-To: <20120423172829.GA2666@kroah.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 11:28 AM, Greg KH wrote:
> On Mon, Apr 23, 2012 at 11:17:19AM -0600, Stephen Warren wrote:
>> On 04/23/2012 06:11 AM, Laxman Dewangan wrote:
>>> ISL29018/ISL29028 is from Intersil Corporation and making the
>>> vendor prefix for this part as "isil" for OF compatibity.
>>>
>>> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
>>
>> I assume this patch will go through the staging tree. Let me know if you
>> want me to take it through the Tegra tree.
> 
> Please take it through the Tegra tree, it is probably easier overall
> that way:
> 	Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Sorry, looking harder, this patch touches a file that's added in the
current staging tree, so I can't take this patch.

There aren't any dependencies between this patch and the others due to
the way I2C probing works (the OF vendor prefix ends up getting
ignored), so I think merging it into staging should be simple.
