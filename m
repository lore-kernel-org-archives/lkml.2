Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab0LFPLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 10:11:10 -0500
Received: from smtprelay02.ispgateway.de ([80.67.31.36]:38240 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab0LFPLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 10:11:08 -0500
Message-ID: <20101206161105.20365wibtcv7jw8w@webmail.df.eu>
Date: Mon, 06 Dec 2010 16:11:05 +0100
From: Bernhard Walle <bernhard@bwalle.de>
To: Jeff Layton <jlayton@samba.org>
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Add information about noserverino
References: <1291568855-22604-1-git-send-email-bernhard@bwalle.de>
 <20101206095725.78422138@tlielax.poochiereds.net>
In-Reply-To: <20101206095725.78422138@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Dynamic Internet Messaging Program (DIMP) H3 (1.1.2)
X-Originating-IP: 212.114.252.242
X-Df-Sender: 1227806
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Zitat von Jeff Layton <jlayton@samba.org>:
>
> This doesn't look right to me...
>
> i_ino is an unsigned long. The code in filldir() is this:
>
>         unsigned long d_ino;

You need to look at compat_filldir():

         compat_ulong_t d_ino;


Regards,
Bernhard


