Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab1HaOv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 10:51:27 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63775 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab1HaOvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 10:51:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Subject: Re: [patch v2 27/35] Hexagon: Provide DMA implementation
Date: Wed, 31 Aug 2011 16:51:07 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org,
        Linas Vepstas <linas@codeaurora.org>
References: <20110830190729.923334292@codeaurora.org> <20110830190802.279215705@codeaurora.org>
In-Reply-To: <20110830190802.279215705@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108311651.07645.arnd@arndb.de>
X-Provags-ID: V02:K0:HGzNgvwMaB/VNG0GKJA4/DvpUQICI7KVgS1fkmvh4lQ
 5wLkUcSEKjlJDpB5OiOYDCp9kZefokxsTkZxQNcdGpcr5Q15Db
 IV4HOGvX/GsTVVsrzahXj+g4khrPTgGnRfk9r21HkFxxWFRfQO
 +lkfU7294b9LTORQz2/ybdYVJ2WyMvhS6q7bn4z6myPBEdbTY9
 cQVJrZirP8PaODC2bFTwWAg9eq7m7iwc7LnjUiBpeErgdzbbTs
 xnoDB4IGyenftXyl7+kUd3KKe5DdM95buwIoc0cnJE0uSawRZd
 VAiGzJTggpmVbRY7KuCNPsxeAq80Zt6i4WSLuVRix9L8xGNkoc
 a3xEsgJ+LkQtsqULtJwg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 August 2011, Richard Kuo wrote:
> Basic DMA implementation for our architecture.
> 
> Added sync_single_for_* routines; hexagon_map_page() still seems to be a
> convenient place to flush/invalidate.
> 
> 
> Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
> Signed-off-by: Linas Vepstas <linas@codeaurora.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
