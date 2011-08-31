Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab1HaNgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 09:36:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62462 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908Ab1HaNgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 09:36:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Subject: Re: [patch v2 07/35] Hexagon: Add threadinfo
Date: Wed, 31 Aug 2011 15:36:03 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
References: <20110830190729.923334292@codeaurora.org> <20110830190800.386603816@codeaurora.org>
In-Reply-To: <20110830190800.386603816@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108311536.03336.arnd@arndb.de>
X-Provags-ID: V02:K0:Vb8aPaAryAy4bdips2y4IDWgyPYdKAYsjP/sTqli4Oj
 i/e7XTvdaBbikIXTDcFRCHha9jFXkN6nhKbLvs3cchrTBNtvSm
 wDfwTctx5XUVHKniLH/h/t+ah3RGhPM/6DzynodmkOaghwnYXv
 4YoIC8eaNK+Mh8+dABuktbpT6R2VVTDkB2LPz0JjYApJEiileW
 B5VQ8xYFE3nIaxK9E8vscGMiWYL9Ku2vtN3vQlAcT8KTA5vF7n
 Ls4OWyMmL3a1v3HHq3/Ug5o3/rl8rbqlQ4UYa0Jm8QYAWJaiH4
 5vuYsqSHS8MtYFEjDkEQKCrgPSzq6wBPRrbyAmlHL7j44l2Pni
 I9hlQx/HLfDyC53PdS/c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 August 2011, Richard Kuo wrote:
> Removed some cruft and changed to allow kernel stack to be smaller than a page
> size.
> 
> I left the thread_info alignment alone for the time being; may revisit that in
> the future.
> 
> Signed-off-by: Richard Kuo <rkuo@codeaurora.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
