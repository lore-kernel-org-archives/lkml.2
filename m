Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437Ab1D2Wgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 18:36:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62104 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab1D2Wgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 18:36:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=pZA0EOUs0wLHraEJDNUSCRzLfgz7WlWDqEb0Xko7EKbsSdzliBX30QsbBE3xz0uqzs
         0I9i6XLeoCVqEnFYBXuU4trqJUa4HZIRX/11DbVtl97R43Zo5J+geUc0l2ai018Io1Jc
         DIq4jWpqXO430m1leToo+4HeUkwNZ289hTUsU=
MIME-Version: 1.0
In-Reply-To: <20110429222548.GC4351@spotteswoode.de.eu.org>
References: <4db8436a.NDzkd3ql2wJdwy2L%Larry.Finger@lwfinger.net>
	<20110428150819.GA3713@spotteswoode.de.eu.org>
	<4DB9884F.10409@lwfinger.net>
	<BANLkTin7Nw1ZjK8UHfypHXY5ZuzafXnJbQ@mail.gmail.com>
	<20110428201527.GA3738@spotteswoode.de.eu.org>
	<BANLkTimi4cUzS5-r_ofzLnjbVtNNjwD69Q@mail.gmail.com>
	<20110429211548.GA4351@spotteswoode.de.eu.org>
	<BANLkTi=-4NaMCMEDxj3CVg6iAmS3DGm0Qw@mail.gmail.com>
	<20110429222548.GC4351@spotteswoode.de.eu.org>
Date: Sat, 30 Apr 2011 06:36:30 +0800
Message-ID: <BANLkTimK-i7aBrFJjGfxQkz-YkLd-ftCnA@mail.gmail.com>
Subject: Re: [PATCH] staging: r8712u: Fix driver to support ad-hoc mode
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: clemens fischer <ino-news@spotteswoode.dnsalias.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, wlanfae@realtek.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 30, 2011 at 6:25 AM, clemens fischer
<ino-news@spotteswoode.dnsalias.org> wrote:
> whereas "r8712u" has only DHCP offers in the logs but no ACKs.

Are you saying you're seeing dhcpd being offered in the log? Please
post the log from the time your mobile starts up the r8712u.

Thanks,
Jeff
