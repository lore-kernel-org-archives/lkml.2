Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab0I2Kex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 06:34:53 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:35665 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab0I2Kew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 06:34:52 -0400
X-Greylist: delayed 1474 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Sep 2010 06:34:52 EDT
X-Spam-Flag: NO
X-Spam-Score: -22.9
Message-ID: <4CA31085.8070507@tudelft.nl>
Date: Wed, 29 Sep 2010 12:10:13 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <E.A.B.Piel@tudelft.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100917 Mandriva/3.1.4-1mdv2011.0 (2011.0) Thunderbird/3.1.4
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] support to overwrite DMI board info
References: <20100928123639.17046.13090.stgit@localhost.localdomain>
In-Reply-To: <20100928123639.17046.13090.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 28-09-10 14:36, Alan Cox schreef:
> From: Jiang, Chao<chao.jiang@intel.com>
>
> support to overwrite board vendor/version/name information by editing
> /boot/cmdline file. Format example:
> 	board_vendor="XXX company" board_version=DV3.0
>
3 new boot parameters... How about also updating 
Documentation/kernel-parameters.txt to explain what they do without 
users having to read the git changelog?

Cheers,
Eric
