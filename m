Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab1HLPel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 11:34:41 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34629 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab1HLPeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 11:34:37 -0400
Subject: Re: TCP port firewall incl. description and english variable names
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tonda <as@strmilov.cz>
Cc: davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1313161843-18226-1-git-send-email-as@strmilov.cz>
References: <1313161843-18226-1-git-send-email-as@strmilov.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Aug 2011 17:34:36 +0200
Message-ID: <1313163276.2354.32.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 12 août 2011 à 17:10 +0200, Tonda a écrit :
> Module that is used to open, close or filter specified TCP port by
> sending certain sequence of UDP packets to predefined UDP ports
> (password-like firewall). One sequence of UDP ports is the opening key
> and sending packets successively to them opens the TCP port and the
> second sequence of UDP ports is the closing key and sending packets
> successively to them closes the TCP port. If between two UDP packets
> in the sequence comes more than 16 another UDP packets, the sequence
> (either opening or closing) is aborted. The configuration and view of
> affected TCP port, opening and closing key and other firewall
> parameters is made throw use of sysfs.
> 
> Signed-off-by: Antoine Steinhauser <as@strmilov.cz>

Antoine

There is no chance this can be added in official linux kernel, its
really too ugly, and can be implemented using standard iptables rules,
and userland controller, adding encryption and other high level stuff if
needed.



