Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933206Ab2KNWmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 17:42:49 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:40741 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933178Ab2KNWmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 17:42:47 -0500
MIME-Version: 1.0
In-Reply-To: <20121114.173304.405703188822325414.davem@davemloft.net>
References: <1352932107-14782-1-git-send-email-grant.likely@secretlab.ca> <20121114.173304.405703188822325414.davem@davemloft.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 14 Nov 2012 22:42:26 +0000
X-Google-Sender-Auth: 2Yv80vACjBD31BmxTx8-VF7uPfU
Message-ID: <CACxGe6vGVK1BQ8Zw+AH3_zSCsCLVfNENb-Qwn45tb+zwC9Mheg@mail.gmail.com>
Subject: Re: [PATCH] drivers/of: Constify device_node->name and ->path_component_name
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        sparclinux@vger.kernel.org, benh@kernel.crashing.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 10:33 PM, David Miller <davem@davemloft.net> wrote:
>
> You're making other changes here, such as the kstrdup() stuff,
> seperate that into another patch.

It's part of the same change. The original code was allocating a
buffer, saving the pointer in the name field and then modifying it.
Making the code to a kstrdup() gets rid of modifying the const buffer.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
