Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab2F1Xmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 19:42:55 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:39618 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab2F1Xmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 19:42:53 -0400
From: Nix <nix@esperi.org.uk>
To: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
Cc: Francois Romieu <romieu@fr.zoreil.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: 3.4.x regression: rtl8169: frequent resets
References: <87y5n7qup0.fsf@spindle.srvr.nix>
	<20120628193026.GA31627@electric-eye.fr.zoreil.com>
	<201206290131.49150.s.L-H@gmx.de>
Emacs: ed  ::  20-megaton hydrogen bomb : firecracker
Date: Fri, 29 Jun 2012 00:42:50 +0100
In-Reply-To: <201206290131.49150.s.L-H@gmx.de> (Stefan Lippers-Hollmann's
	message of "Fri, 29 Jun 2012 01:31:42 +0200")
Message-ID: <877gurovet.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-INFN-TO-Metrics: spindle 1233; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 Jun 2012, Stefan Lippers-Hollmann uttered the following:
> I received the same oops from a 3.4.4 user with these onboard network 
> cards:

Pedant point: it's not an oops, just a slowpath warning.

>                                                        no oops in 21
> hours uptime so far (while it usually shows up within about an hour).

Interesting. I wonder why it took two days to show up for me. It's not
like I'm a very light network user or anything, there are easily 300
packets per second in each direction on this interface every second of
the day (and often much more).

-- 
NULL && (void)
