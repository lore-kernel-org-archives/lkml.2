Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab2H2ROG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 13:14:06 -0400
Received: from mail.tpi.com ([70.99.223.143]:4948 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153Ab2H2ROA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 13:14:00 -0400
Message-ID: <503E4DBB.4030606@canonical.com>
Date: Wed, 29 Aug 2012 11:13:31 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
        Eliad Peller <eliad@wizery.com>, Arik Nemtsov <arik@wizery.com>,
        Eyal Shapira <eyal@wizery.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 3.6-rc3] wlcore: Declare MODULE_FIRMWARE usage
References: <1346251689-37023-1-git-send-email-tim.gardner@canonical.com> <1346259706.3935.2.camel@cumari.coelho.fi>
In-Reply-To: <1346259706.3935.2.camel@cumari.coelho.fi>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2012 11:01 AM, Luciano Coelho wrote:
> On Wed, 2012-08-29 at 08:48 -0600, Tim Gardner wrote:
>> Cc: Luciano Coelho <coelho@ti.com>
>> Cc: "John W. Linville" <linville@tuxdriver.com>
>> Cc: Eliad Peller <eliad@wizery.com>
>> Cc: Arik Nemtsov <arik@wizery.com>
>> Cc: Eyal Shapira <eyal@wizery.com>
>> Cc: linux-wireless@vger.kernel.org
>> Cc: netdev@vger.kernel.org
>> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
>> ---
> 
> Please add a proper commit message.  And there's no need to put all
> these people in Cc: in the commit log.  CC'ing when sending the patch is
> enough (even though for such small patch, the linux-wireless mailing
> list and myself is enough).
> 
> --
> Luca.
> 

What more would you like covered in the commit message that isn't
obvious from the subject?

The Cc list comes from scripts/get_maintainers.pl as suggested by
Documentation/SubmittingPatches: "5) Select e-mail destination."

rtg
-- 
Tim Gardner tim.gardner@canonical.com
