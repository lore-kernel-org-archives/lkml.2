Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab0F3XMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 19:12:13 -0400
Received: from lo.gmane.org ([80.91.229.12]:50642 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755283Ab0F3XMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 19:12:12 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Subject: Re: [PATCH 06/33] Removing dead SHARPSL_LOCOMO
Date: Wed, 30 Jun 2010 23:12:01 +0000 (UTC)
Message-ID: <i0gj01$i9n$1@dough.gmane.org>
References: <cover.1277911345.git.siccegge@cs.fau.de>
	<b43850b1a1909496718e39687d1ca00543aa30ec.1277911346.git.siccegge@cs.fau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: ppp89-110-1-16.pppoe.avangarddsl.ru
User-Agent: Pan/0.133 (House of Butterflies)
Cc: linux-arm-kernel@lists.infradead.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Egger wrote:

> SHARPSL_LOCOMO doesn't exist in Kconfig, therefore removing all
> references for it from the source code.

Hmmm. Shouldn't this be instead just SHARP_LOCOMO?

> 
> Signed-off-by: Christoph Egger <siccegge@cs.fau.de> ---



-- 
With best wishes
Dmitry


