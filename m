Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab1BXP0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 10:26:40 -0500
Received: from cantor.suse.de ([195.135.220.2]:50962 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108Ab1BXP0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 10:26:37 -0500
Message-ID: <4D6678AA.9000503@suse.cz>
Date: Thu, 24 Feb 2011 16:26:34 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] kbuild: reenable section mismatch analysis
References: <20110216200734.GA25184@merkur.ravnborg.org> <1298062040-2774-1-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1298062040-2774-1-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.2.2011 21:47, Uwe Kleine-König wrote:
> This was disabled in commit
> 
> 	e5f95c8 (kbuild: print only total number of section mismatces found)
> 
> because there were too many warnings.  Now we're down to a reasonable
> number again, so we start scaring people with the details.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

OK, applied to kbuild-2.6.git#kbuild.

Thanks,
Michal
