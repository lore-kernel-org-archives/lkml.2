Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab1HLPNx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 11:13:53 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:33390 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751164Ab1HLPNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 11:13:50 -0400
Date: Fri, 12 Aug 2011 08:13:48 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Tonda <as@strmilov.cz>
Cc: davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: TCP port firewall incl. description and english variable names
Message-Id: <20110812081348.02ec45d0.rdunlap@xenotime.net>
In-Reply-To: <1313161843-18226-1-git-send-email-as@strmilov.cz>
References: <1313161843-18226-1-git-send-email-as@strmilov.cz>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Aug 2011 17:10:43 +0200 Tonda wrote:

> Module that is used to open, close or filter specified TCP port by sending certain sequence of UDP packets to predefined UDP ports (password-like firewall). One sequence of UDP ports is the opening key and sending packets successively to them opens the TCP port and the second sequence of UDP ports is the closing key and sending packets successively to them closes the TCP port. If between two UDP packets in the sequence comes more than 16 another UDP packets, the sequence (either opening or closing) is aborted. The configuration and view of affected TCP port, opening and closing key and other firewall parameters is made throw use of sysfs.

> Signed-off-by: Antoine Steinhauser <as@strmilov.cz>
> 
> diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
> --- a/net/ipv4/Kconfig
> +++ b/net/ipv4/Kconfig
> @@ -624,3 +624,7 @@
>  	  on the Internet.
>  
>  	  If unsure, say N.
> +
> +config TCPFIREWALL
> +	tristate "TCP Firewall controlled by UDP queries"
> +	depends on m

I have the same comments as yesterday, which for some reason were
unanswered.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
