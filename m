Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab1LBAlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 19:41:04 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37891 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102Ab1LBAlA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 19:41:00 -0500
MIME-Version: 1.0
In-Reply-To: <CA+8MBbJ4Tu86jSbaBRjDKfowwVE12jY3efK7QMm74e7i8aq4Hg@mail.gmail.com>
References: <1321457231-9154-1-git-send-email-jslaby@suse.cz>
	<1321457231-9154-2-git-send-email-jslaby@suse.cz>
	<CA+8MBbJ4Tu86jSbaBRjDKfowwVE12jY3efK7QMm74e7i8aq4Hg@mail.gmail.com>
Date: Thu, 1 Dec 2011 16:40:59 -0800
X-Google-Sender-Auth: iLAozoM1TZyMkp19_rWyQ28IvpU
Message-ID: <CA+8MBbLoMzQGCk+57CuDKLAAi+K_1CSxCznyHYK=AFC0WEMRXQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] TTY: ldisc, move wait idle to caller
From: Tony Luck <tony.luck@intel.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Dave Young <hidave.darkstar@gmail.com>, Dave Jones <davej@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Dmitriy Matrosov <sgf.dma@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, stable <stable@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 1, 2011 at 3:01 PM, Tony Luck <tony.luck@intel.com> wrote:
> [Though the following commit "TTY: ldisc, wait for ldisc infinitely in hangup"
>  sounds like it fits the symptoms]

Confirmed - reverting the "wait for ldisc infinitely" cures the hang problem (I
do seem to be hitting the 5 second delay, and there is a pause that feels
about 5 seconds long)

-Tony
