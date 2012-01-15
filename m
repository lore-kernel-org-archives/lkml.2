Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707Ab2AOJV5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 04:21:57 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:33369 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751340Ab2AOJVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 04:21:53 -0500
Message-ID: <1326619310.6164.2.camel@joe2Laptop>
Subject: Re: [PATCH 3/8] brcm80211: Add and use brcmX_dbg_dump_hex
From: Joe Perches <joe@perches.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Brett Rudley <brudley@broadcom.com>,
        Henry Ptasinski <henryp@broadcom.com>,
        Roland Vossen <rvossen@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        Kan Yan <kanyan@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Sun, 15 Jan 2012 01:21:50 -0800
In-Reply-To: <4F1299C4.7020902@broadcom.com>
References: <cover.1326616556.git.joe@perches.com>
	 <289e8a2dcdbb03315ba41788a358f5afc4bacb1b.1326616556.git.joe@perches.com>
	 <4F1299C4.7020902@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-01-15 at 10:17 +0100, Arend van Spriel wrote:
> On 01/15/2012 09:38 AM, Joe Perches wrote:
> 
> > +#ifdef DEBUG
> > +extern __printf(3, 4)
> 
> Just curious if I can learn something here. What does the __printf(3, 4) do?

It's a #define for gcc __attribute__((format (printf, ...)))
It makes gcc validate the printf format and arguments.

http://gcc.gnu.org/onlinedocs/gcc/Function-Attributes.html


