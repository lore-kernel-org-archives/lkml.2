Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745Ab2DYCLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 22:11:38 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51749 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757115Ab2DYCLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 22:11:36 -0400
Date: Tue, 24 Apr 2012 21:11:24 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Matt Turner <mattst88@gmail.com>
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Cree <mcree@orcon.net.nz>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Ben Hutchings <ben@decadent.org.uk>,
        =?utf-8?B?UmHDumw=?= Porcel <armin76@gentoo.org>
Subject: Re: [PATCH] alpha: add io{read,write}{16,32}be functions
Message-ID: <20120425021124.GA3017@burratino>
References: <1322640100-14534-1-git-send-email-mcree@orcon.net.nz>
 <20120424055123.GA7140@burratino>
 <CAEdQ38HE70B-4w3t71rn_S-eX7BMnc6f=dD49guuBim+dQnPzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEdQ38HE70B-4w3t71rn_S-eX7BMnc6f=dD49guuBim+dQnPzA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Turner wrote:

> I recently got my kernel.org tree set up again, so I just applied
> this.

Thanks!  Glad to see more DEC syscalls flowing in.
