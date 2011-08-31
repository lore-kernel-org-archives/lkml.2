Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab1HaNlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 09:41:11 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51846 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662Ab1HaNlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 09:41:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Subject: Re: [patch v2 11/35] Hexagon: Add hypervisor interface
Date: Wed, 31 Aug 2011 15:41:06 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
References: <20110830190729.923334292@codeaurora.org> <20110830190800.794824955@codeaurora.org>
In-Reply-To: <20110830190800.794824955@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108311541.06688.arnd@arndb.de>
X-Provags-ID: V02:K0:AKgHrfloCGhJL3I6sLqQILkhqNDtGJftam963s3KgF3
 ccaf+x9HsR/HfZJQyZedjJ5fnxMTiFuz7UKOcU7I5gYkXbHCb/
 FqHxQGh1GZr2ZUI6L95oEcXy/olJsSq8iuGhOWioBbss04MB8i
 0yaAjdqUWEP/E14obf5U64iVE1u1OA84sQG+ugkMQozwX+Hc29
 kLBFXLTlpgAU3JIE7M9WN8Jdjz2elvT+YQuEZxTg2aup1bHonB
 WymzSgmam/93pJG40iJ5ushpCt/VjtY4bR9BjjmypZ0LDUqDDA
 CFtAgyvQ46P8rXo/HutrJUoEgrEP+8x+or2Ub6RFQhfXGUeT6w
 yQQDeHkulbP4R5Rl+hQQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 August 2011, Richard Kuo wrote:
> The port of Linux for Hexagon runs on top of a hypervisor layer,
> which presents an interface for memory management, events, hardware
> control, etc.
> 
> Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
> 
Acked-by: Arnd Bergmann <arnd@arndb.de>
