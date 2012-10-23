Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab2JWWQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 18:16:04 -0400
Received: from smtp-01.mandic.com.br ([200.225.81.132]:47051 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab2JWWQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 18:16:02 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Oct 2012 18:16:02 EDT
Message-ID: <5087158E.4040201@cesarb.net>
Date: Tue, 23 Oct 2012 20:09:18 -0200
From: Cesar Eduardo Barros <cesarb@cesarb.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 090/193] drivers/net/ethernet/silan: remove CONFIG_EXPERIMENTAL
References: <1351022666-6960-1-git-send-email-keescook@chromium.org> <1351022666-6960-91-git-send-email-keescook@chromium.org>
In-Reply-To: <1351022666-6960-91-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 23-10-2012 18:02, Kees Cook escreveu:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Cesar Eduardo Barros <cesarb@cesarb.net>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Cesar Eduardo Barros <cesarb@cesarb.net>

-- 
Cesar Eduardo Barros
cesarb@cesarb.net
cesar.barros@gmail.com
