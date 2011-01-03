Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab1ACSWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 13:22:37 -0500
Received: from solo.fdn.fr ([80.67.169.19]:55553 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab1ACSWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 13:22:36 -0500
Date: Mon, 3 Jan 2011 19:22:32 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Russell Coker <russell@coker.com.au>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] char nvtty: Network Virtual Terminal support
Message-ID: <20110103182232.GB5121@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
	Russell Coker <russell@coker.com.au>,
	Greg Kroah-Hartman <gregkh@suse.de>
References: <1294067735-21466-1-git-send-email-giometti@linux.it> <1294067735-21466-2-git-send-email-giometti@linux.it> <20110103171452.5e258743@lxorguk.ukuu.org.uk> <20110103180247.GF22102@gundam.enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110103180247.GF22102@gundam.enneenne.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rodolfo Giometti, le Mon 03 Jan 2011 19:02:47 +0100, a écrit :
> but as far as I know pty/tty
> pairs cannot be used to report termios settings but only data... is
> that right? =:-o

ptys are meant to let you deal with termios, precisely (contrary to mere
pipes for instance).

Samuel
