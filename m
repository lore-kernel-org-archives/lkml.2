Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031210Ab2CFWPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 17:15:33 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62259 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030811Ab2CFWPb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 17:15:31 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jwboyer@gmail.com designates 10.52.34.4 as permitted sender) smtp.mail=jwboyer@gmail.com; dkim=pass header.i=jwboyer@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120306.170819.2135873666210523674.davem@davemloft.net>
References: <1330920224-3006-1-git-send-email-dhdang@apm.com>
	<1330945062-15760-1-git-send-email-dhdang@apm.com>
	<20120306.170819.2135873666210523674.davem@davemloft.net>
Date: Tue, 6 Mar 2012 17:15:30 -0500
Message-ID: <CA+5PVA56KhuBjbszR8_k_OAyQc=1fHxbMXE4ZFO9ahANVJi_Ww@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] powerpc/44x: Add new compatible value for EMAC
 node of APM821XX dts file.
From: Josh Boyer <jwboyer@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: dhdang@apm.com, benh@kernel.crashing.org, paulus@samba.org, sr@denx.de,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 5:08 PM, David Miller <davem@davemloft.net> wrote:
> From: Duc Dang <dhdang@apm.com>
> Date: Mon,  5 Mar 2012 17:57:42 +0700
>
>> This compatible value will be used to distinguish some special features of APM821XX EMAC: no half duplex mode support, configuring jumbo frame.
>>
>> Signed-off-by: Duc Dang <dhdang@apm.com>
>
> Applied.

So I guess we're taking these through your tree?  I guess that works out
well enough since the other patches I was going to send to Ben aren't
panning out anyway.

josh
