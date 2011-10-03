Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab1JCJ3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 05:29:11 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57327 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494Ab1JCJ3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 05:29:01 -0400
Message-ID: <4E898059.7040107@gmail.com>
Date: Mon, 03 Oct 2011 11:28:57 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Willy Tarreau <w@1wt.eu>, Steven Rostedt <rostedt@goodmis.org>,
        David Miller <davem@davemloft.net>, greg@kroah.com,
        linux-kernel@vger.kernel.org
Subject: Re: kernel.org status: hints on how to check your machine for intrusion
References: <20110930235924.GA25176@kroah.com> <20111001073533.GA18690@1wt.eu> <20111001180641.GD6309@home.goodmis.org> <20111001.141343.2293070262147973147.davem@davemloft.net> <1317493763.4588.70.camel@gandalf.stny.rr.com> <20111001183448.GD18690@1wt.eu> <20111001212321.GE23355@khazad-dum.debian.net> <20111001213025.GF23355@khazad-dum.debian.net>
In-Reply-To: <20111001213025.GF23355@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2011 11:30 PM, Henrique de Moraes Holschuh wrote:
> Hmm, and a last tip:
>
> Always use the "AllowUsers" or "AllowGroups" directive in sshd_config to
> only allow access to whitelisted users/groups and deny to every other user
> (including system ones).
>
Also nice is a dumb iptables filter with the recent match. 2 lines total.
http://www.linux-noob.com/forums/index.php?/topic/1829-ssh-rate-limit-per-ip-new-method/

But denyhosts does blacklisting for sshd automatically. :)
http://denyhosts.sourceforge.net/faq.html

~Maarten
