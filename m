Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab2ENUWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:22:12 -0400
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:6961 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932340Ab2ENUV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:21:56 -0400
X-Greylist: delayed 583 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 May 2012 16:21:55 EDT
X-Loopcount0: from 10.9.160.253
Message-ID: <4FB16659.6040704@dell.com>
Date: Mon, 14 May 2012 15:08:57 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
Organization: Dell Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Kamal Mostafa <kamal@canonical.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dell-laptop: rfkill blacklist Dell XPS 13z, 15z
References: <1337023652-11661-1-git-send-email-kamal@canonical.com> <20120514193718.GA6438@srcf.ucam.org>
In-Reply-To: <20120514193718.GA6438@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05/14/2012 02:37 PM, Matthew Garrett wrote:
> What does "Improper BIOS interaction" mean? What's the proper BIOS interaction?
These platforms are not obeying the smbios interface specs for turning on and off radios.  It's not currently expected that the interaction will improve during the lifetime of these platforms.  If it does, then this can be adjusted to only apply to the BIOS versions before the fix.

-- 
*Mario Limonciello*
Linux Engineer
*Dell*| OS Engineering
