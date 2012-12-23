Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab2LWXde (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 18:33:34 -0500
Received: from 1wt.eu ([62.212.114.60]:37234 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285Ab2LWXdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 18:33:32 -0500
Date: Mon, 24 Dec 2012 00:33:13 +0100
From: Willy Tarreau <w@1wt.eu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Jonathan Nieder <jrnieder@gmail.com>, stable@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, x86@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, Keith Ward <keith@chaos-realm.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [2.6.32.y, 2.6.34.y] Re: [PATCH] x86: Don't use the EFI reboot method by default
Message-ID: <20121223233313.GI3263@1wt.eu>
References: <1309985557-15350-1-git-send-email-mjg@redhat.com> <20121223205950.GA16511@elie.Belkin> <20121223210348.GG3263@1wt.eu> <1356297096.21837.27.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356297096.21837.27.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2012 at 09:11:36PM +0000, Ben Hutchings wrote:
(...)
> In 2.6.32 the relevant code is in arch/x86/kernel/efi.c.  With the
> filename changed, the patch applies cleanly and works for me.

OK, thanks Ben, I had not looked at it yet.

Best regards,
Willy

