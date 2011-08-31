Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab1HaNfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 09:35:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55875 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902Ab1HaNf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 09:35:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Subject: Re: [patch v2 06/35] Hexagon: Add processor and system headers
Date: Wed, 31 Aug 2011 15:35:25 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org,
        Linas Vepstas <linas@codeaurora.org>
References: <20110830190729.923334292@codeaurora.org> <20110830190800.292243127@codeaurora.org>
In-Reply-To: <20110830190800.292243127@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108311535.25248.arnd@arndb.de>
X-Provags-ID: V02:K0:dnQyIQV7z8aZRAlGug3WFtkFZTiWodnBDgTNYyQMa4u
 Th3zJG8Qr3sqGWImP5wAsKE/lfF9iARXGn7yXV7pt/Dnfe05qq
 NUZZv8xYKZozYaa78TRGzZF5mtMS1JdR6TyCSjZZDFIFXDCBu8
 J15XDNniAQ/sLpO/IQjEOkNpvk9WT6l5KWf22/GeXtdwW8PDiQ
 b/nhriwggXHpngz+guZi9i30hkkqGCVdSKPUp8irlbf0Fqtsye
 KO4oB1rIYZWw0WbZVlG6Hf/GcLHKN0bjBZagbHw08AIQJnOPDy
 dA86l72q5TtsVB36T4f8A+3TQaXArmCiakT3AlyJdSuwXB9F7R
 vUGb/FTTL+UKGX6IeDsU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 August 2011, Richard Kuo wrote:
> 
> Adds Hexagon information for processor/system type stuff
> like context switching, register access, and irqflags.
> 
> Changed cpu_relax() to call __vmyield().
> 
> Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
> Signed-off-by: Linas Vepstas <linas@codeaurora.org>
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
