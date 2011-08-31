Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab1HaOt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 10:49:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64982 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755830Ab1HaOtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 10:49:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Subject: Re: [patch v2 26/35] Hexagon: Implement basic TLB management routines for Hexagon.
Date: Wed, 31 Aug 2011 16:49:49 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
References: <20110830190729.923334292@codeaurora.org> <20110830190802.185888808@codeaurora.org>
In-Reply-To: <20110830190802.185888808@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108311649.49762.arnd@arndb.de>
X-Provags-ID: V02:K0:2lOBjYB9dWp9jhKzIIuy9VryhSVGkGDAbeGq5u5NALi
 P9TTA9jHR4gtgVPCwNM1zz+qTUI4ZLsQS42CbJyaqs1oCw1gRZ
 4X3z+zpqELZxf0ES7iJz2yD0QuqkE+UmdIlbODN0lzES8cVFQZ
 8SR2zQyScdQkGsKpRmPC6bObo8tG1ytVj8jB6F61UqttW6cPub
 zyhjgdFlrOQMjtYsz1fnzgYqm7YmkA4+7Doyn2V/VIGH1RfLY2
 kxi2QW1aYbn0o8qnIenmPCnyM5A2AFQZv9rtf56ZA/gDHMBvMO
 gCfZVSdMJef7Es8hTE96ENhuWnoqz45mFkB6hnAIRPJYgtzuby
 NTG1xoitdDMjCbWRI9M4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 August 2011, Richard Kuo wrote:
> 
> Mostly all stubs, as the TLB is managed by the hypervisor.
> 
> Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
> 
Acked-by: Arnd Bergmann <arnd@arndb.de>
