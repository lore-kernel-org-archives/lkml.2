Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319Ab2IGTwu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:52:50 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57914 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291Ab2IGTws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:52:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 27/31] arm64: Loadable modules
Date: Fri, 7 Sep 2012 19:52:45 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com> <1347035226-18649-28-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1347035226-18649-28-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201209071952.45895.arnd@arndb.de>
X-Provags-ID: V02:K0:I+fYJU1TuQCeynKsusEmdwCKkXCRg+pypHucMCG0rcB
 DnXhVLUOPrgZelWQTHRn01FZ5So8MMGupQpFjxgjGGMVo64esV
 MyxgiF0+GSAfYWrRXRgPydZtCwGRjzpSHwQcBfEXQ/lsmT3D3f
 xgTTaPY6mjbxrJS59/SV1ZcJe+W1ZwsQbPHK85sLm7iBNTP9+n
 kfU3iEaqkh4xh/wRvs8IKFedbAv28y8uZOmMF06/tP2A0SKNs+
 WtR/wYMrOM0vnBS0udTeC5SVJyv1+cIAg71JyR0VUTDVepQfxt
 90eGr1F0zkjP7+QWqpU+3QuzB5NDu5VH9W972VtnsrCYIn/CVO
 +LJfdKqHAirCZo1z8ifk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2012, Catalin Marinas wrote:
> From: Will Deacon <will.deacon@arm.com>
> 
> This patch adds support for loadable modules. Loadable modules are
> loaded 64MB below the kernel image due to branch relocation restrictions
> (see Documentation/arm64/memory.txt).
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Tony Lindgren <tony@atomide.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
