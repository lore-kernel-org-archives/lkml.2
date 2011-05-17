Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab1EQTob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 15:44:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:51499 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932086Ab1EQToa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 15:44:30 -0400
Message-ID: <4DD2D017.8050609@suse.cz>
Date: Tue, 17 May 2011 21:44:23 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: Only generate config_is_xxx for bool and tristate
 options
References: <1305646532-29114-1-git-send-email-mmarek@suse.cz> <20110517180518.GC18699@game.jcrosoft.org>
In-Reply-To: <20110517180518.GC18699@game.jcrosoft.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.5.2011 20:05, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 17:35 Tue 17 May     , Michal Marek wrote:
>> For strings and integers, the config_is_xxx macros are useless and
>> sometimes misleading:
> except if the interger or hex can be at 0
> so the config_is_ is usefull to known that it's enabled

You can check if the option that the integer depends on is enabled.


>>   #define CONFIG_INITRAMFS_SOURCE ""
>>   #define config_is_initramfs_source() 1
> here agreed but I'm nor sure if it's a special case or if it will we the case
> for most of the string

Same here.

Michal
