Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab0GNRGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 13:06:55 -0400
Received: from mail.candelatech.com ([208.74.158.172]:50972 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab0GNRGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 13:06:54 -0400
Message-ID: <4C3DEEAB.8090106@candelatech.com>
Date: Wed, 14 Jul 2010 10:06:51 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
CC: Robert Hancock <hancockrwd@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
Subject: Re: Regression: 2.6.34 boot fails on E5405 system, bisected: 	de08e2c26
References: <4C3D067C.10507@candelatech.com>	<4C3D101E.5010605@candelatech.com>	<4C3D1942.1090207@gmail.com>	<4C3D1F82.1040907@candelatech.com> <AANLkTinDv7I4v51j-Lev9Ry_3DyVVv58lAyCQXZV1CwB@mail.gmail.com> <4C3DC64F.5040505@candelatech.com> <43F901BD926A4E43B106BF17856F0755EA8EE7E2@orsmsx508.amr.corp.intel.com>
In-Reply-To: <43F901BD926A4E43B106BF17856F0755EA8EE7E2@orsmsx508.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2010 08:36 AM, Pan, Jacob jun wrote:
> what is the config size of 10.1?
> ls -l /sys/bus/pci/devices/0000:00:10.1/config
>
> if that is 256, it might be related to this patch.

That patch is already in 2.6.34.y (with slight white-space
change it seems:  space before <).

I just posted a patch to lkml that fixes the problem for me,
based on a suggestion by Robert Hancock.

I think this or something similar should to go 2.6.34.y stable
as well.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

