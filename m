Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323Ab0HSEij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 00:38:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:21613 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911Ab0HSEih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 00:38:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,231,1280732400"; 
   d="scan'208";a="546683456"
Message-ID: <4C6CB54A.4090605@linux.intel.com>
Date: Wed, 18 Aug 2010 21:38:34 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-parisc@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Helge Deller <deller@gmx.de>
Subject: Re: [PATCHv2 2/1] Consolidate CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
References: <201008181428.45029.arnd@arndb.de> <1282184898-30599-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1282184898-30599-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/18/2010 7:28 PM, Stephen Boyd wrote:
> The help text for this config is duplicated across the x86,
> parisc, s390, and arm Kconfig.debug files. Arnd Bergman noted
> that the help text was slightly misleading and should be fixed to
> state that enabling this option isn't a problem when using pre 4.4
> gcc.
>
> To simplify the rewording, consolidate the text into
> lib/Kconfig.debug and modify it there to be more explicit about
> when you should say N to this config.
>    


Acked-by: Arjan van de Ven <arjan@linux.intel.com>
