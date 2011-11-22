Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab1KVOLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 09:11:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755894Ab1KVOLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 09:11:42 -0500
Date: Tue, 22 Nov 2011 15:14:13 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Arnd Hannemann <arnd@arndnet.de>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: 3.2.0-rc2: WARNING: at iwlwifi/wl-trans-pcie.c:1105
Message-ID: <20111122141412.GB3891@redhat.com>
References: <4EC6DE6B.3080603@arndnet.de>
 <4ECB65A5.3010009@arndnet.de>
 <CANUX_P1RXxRuybzj0gavVOkN-a3H_qRO45S1nc3oPq1aZe5V3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANUX_P1RXxRuybzj0gavVOkN-a3H_qRO45S1nc3oPq1aZe5V3g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 01:47:53PM +0200, Emmanuel Grumbach wrote:
> > additional to the WARNING wireless with iwlwifi seems to be very flaky on 3.2.0-rc2.
> Yeah I know about that one. I haven't found the time to look at it yet.
> I do have a patch that can help to debug. This patch will be sent
> through the regular channel.
> I am considering to remove the warning though

Just after the warning there is "Queue stuck" message, without warning
there will be no hint what is causing firmware hung.

Stanislaw
