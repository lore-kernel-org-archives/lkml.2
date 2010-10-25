Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310Ab0JYSBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 14:01:20 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47469 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759262Ab0JYSBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 14:01:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Gsb3xRd87iLQrt4VY/VTI1s2dQFfobfEhUiN+vrf+I9RTGUCb7chY+qc0J8FnS4nrh
         OAaSUELY8tyesyS8AfwEizga0PrgvBWNLWIYSiEyLcoQ98Sbk4qszayKRS6sgridVUZ5
         3ydJS2jdC9ABJt/TxDztsNHEwN4aYPg7AFW5w=
Message-ID: <4CC5C5F5.3080607@lwfinger.net>
Date: Mon, 25 Oct 2010 13:01:25 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100914 SUSE/3.0.8 Thunderbird/3.0.8
MIME-Version: 1.0
To: htl10@users.sourceforge.net
CC: "John W. Linville" <linville@tuxdriver.com>,
        Serafeim Zanikolas <sez@debian.org>, herton@mandriva.com.br,
        joe@perches.com, davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: rtl818x: request DMA-able memory
References: <902045.66378.qm@web29504.mail.ird.yahoo.com>
In-Reply-To: <902045.66378.qm@web29504.mail.ird.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2010 10:39 AM, Hin-Tak Leung wrote:
> 
> okay - sorry about the confusion - I was grep'ing for GFP_DMA and only b43/b43lagacy have it and it is relatively rare. AFAIK none of the rtl8187 devices are non-USB... probably a NACK then, but I should ask Serafeim if there is a reason for him to submit this patch? (other than "it says dma"...) 

There are some devices driven by b43/b43legacy that implement only 24-bit DMA.
For that reason, they need to allocate DMA buffers in the low 16 MB of RAM. For
rtl8187, that consideration does not apply.

Larry
