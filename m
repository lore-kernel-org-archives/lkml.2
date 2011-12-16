Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760626Ab1LPTmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:42:37 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41608 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab1LPTma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:42:30 -0500
Message-ID: <1324064546.2621.22.camel@edumazet-laptop>
Subject: Re: [PATCH net-next v1 5/6] tg3: implementation of a non-NAPI mode
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Decotigny <decot@googlers.com>
Cc: Matt Carlson <mcarlson@broadcom.com>, Michael Chan <mchan@broadcom.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <martinez.javier@gmail.com>,
        Robin Getz <rgetz@blackfin.uclinux.org>,
        Matt Mackall <mpm@selenic.com>, Tom Herbert <therbert@google.com>
Date: Fri, 16 Dec 2011 20:42:26 +0100
In-Reply-To: <6d55ce25f5f237a4538f6a2fcd2609b877669297.1324059527.git.decot@googlers.com>
References: <cover.1324059527.git.decot@googlers.com>
	 <6d55ce25f5f237a4538f6a2fcd2609b877669297.1324059527.git.decot@googlers.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 16 décembre 2011 à 10:19 -0800, David Decotigny a écrit :
> From: Tom Herbert <therbert@google.com>
> 
...
> 
> 
> Signed-off-by: David Decotigny <decot@googlers.com>
> ---

If patch author is Tom Herbert, you should use :

Signed-off-by: Tom Herbert <therbert@google.com>
Signed-off-by: David Decotigny <decot@googlers.com>


(Same problem on other patches)



