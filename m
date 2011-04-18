Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab1DRIQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 04:16:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35180 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab1DRIQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 04:16:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Q8xr1yP5saWtG6cMde+n9MqUGTBpn7d6W3ULQJwM4f/5iBR2qIlt9KCHwE6WaPIBTf
         /ZJ39Nj6BRIje2LFC7ezEO7rIo1+YfW5/xqlzOBKBqtsL5/VVP2z8qdM0jvAiwPJKNv3
         zom0cPawmAX6e7C8JFzqUZZNecl8eIobZ5qwg=
Date: Mon, 18 Apr 2011 10:16:03 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mike Frysinger <vapier@gentoo.org>, Paul Mackerras <paulus@samba.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH V14 3/4] ptp: Added a clock driver for the IXP46x.
Message-ID: <20110418081603.GB3809@riccoc20.at.omicron.at>
References: <cover.1303107532.git.richard.cochran@omicron.at>
 <dbee2487a57fd7f41e4efbbd2ddfb1313b8d71bc.1303107532.git.richard.cochran@omicron.at>
 <201104180856.04186.arnd@arndb.de>
 <20110418080606.GA3809@riccoc20.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110418080606.GA3809@riccoc20.at.omicron.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Also, I forgot to add Krzysztof's ack to the commit message, but he
did ack V12.

Thanks,
Richard
