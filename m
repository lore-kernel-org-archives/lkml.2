Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab1HaNlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 09:41:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63606 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023Ab1HaNlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 09:41:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Subject: Re: [patch v2 13/35] Hexagon: Support dynamic module loading.
Date: Wed, 31 Aug 2011 15:41:45 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org,
        Linas Vepstas <linas@codeaurora.org>
References: <20110830190729.923334292@codeaurora.org> <20110830190800.974918693@codeaurora.org>
In-Reply-To: <20110830190800.974918693@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108311541.45530.arnd@arndb.de>
X-Provags-ID: V02:K0:ze5lttxkAyUuu8WwvRcXylWlVSeLWlGgVPLa+r49viv
 VzlyGVUmNs72fKkuOoEygtNaodp4zIaInQX3XPKOcAkRH/bLfR
 V9Tic7S9aGP13j30i3R5PjfPvrRPk/5wuHrz7gKketmS+WgD02
 +PknO5hWdIFSQ9D0ndAUHFX84BRbE/QFAoj3a8blJl7a/MTyGc
 BYU2nOiCpA+M6amJN3b5m0+vGAxceHG6soxbzSSvmp2cnFbyNx
 HFeTsTFEZUEMyL+i33quzoPW1vNrmRDLDjwfdtf4w6QspTSSZB
 WdpmZKG6hdY7iJ3ti0ZcOUtieFZHcHsqXi6PUohWFhiujf7IJX
 PjGqFB/WWzV/v6dwbsiw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 August 2011, Richard Kuo wrote:
> 
> Modules should be compiled as ordinary .o's; shared objects are not
> supported.
> 
> Deleted module functions that already have generic equivalents.
> 
> Signed-off-by: Linas Vepstas <linas@codeaurora.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
