Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab2GIDcQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 23:32:16 -0400
Received: from tundra.namei.org ([65.99.196.166]:43999 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab2GIDcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 23:32:14 -0400
Date: Mon, 9 Jul 2012 13:32:03 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Vincent Sanders <vincent.sanders@collabora.co.uk>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH net-next 04/15] security: Add Linux Security Modules hook
 for AF_BUS sockets
In-Reply-To: <1340988354-26981-5-git-send-email-vincent.sanders@collabora.co.uk>
Message-ID: <alpine.LRH.2.02.1207091330410.1482@tundra.namei.org>
References: <1340988354-26981-1-git-send-email-vincent.sanders@collabora.co.uk> <1340988354-26981-5-git-send-email-vincent.sanders@collabora.co.uk>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jun 2012, Vincent Sanders wrote:

> From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> 
> AF_BUS implements a security hook bus_connect() to be used by LSM to
> enforce connectivity security policies.

Nack.

Changes to LSM should be cc'd the LSM list and Paul Moore.



- James
-- 
James Morris
<jmorris@namei.org>
