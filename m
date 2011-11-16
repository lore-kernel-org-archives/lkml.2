Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab1KPS5E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 13:57:04 -0500
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:11270
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751336Ab1KPS5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 13:57:02 -0500
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
Message-ID: <4EC40778.5020208@freescale.com>
Date: Wed, 16 Nov 2011 12:56:56 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111107 Firefox/8.0 SeaMonkey/2.5
MIME-Version: 1.0
To: <guenter.roeck@ericsson.com>
CC: York Sun <yorksun@freescale.com>, Jean Delvare <khali@linux-fr.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "B29983@freescale.com" <B29983@freescale.com>
Subject: Re: [PATCH] i2c/busses: (mpc) Add support for SMBUS_READ_BLOCK_DATA
References: <1321338462-6138-1-git-send-email-guenter.roeck@ericsson.com>  <CAOZdJXUPO5PyMkAw-2EPvy_qSUuqsgUA7Gr8mKUX7HyShoXk3g@mail.gmail.com>  <E6AF40B3BFC8A9428EACB47497F0F4B62DC687@039-SN1MPN1-002.039d.mgd.msft.net>  <ECEE0D23-8F53-402C-A97F-4DB0F0E9C79B@freescale.com>  <1321464509.7847.41.camel@oslab-l1>  <1321464968.2309.384.camel@groeck-laptop>  <1321466135.7847.55.camel@oslab-l1>  <20111116190954.67c846fc@endymion.delvare>  <1321467638.7847.73.camel@oslab-l1> <1321469491.2309.409.camel@groeck-laptop>
In-Reply-To: <1321469491.2309.409.camel@groeck-laptop>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guenter Roeck wrote:
> I simply don't have time for this, and spent way too much time on it
> already. Jean, please drop this patch. If someone else needs it, he or
> she can revive and re-submit it. If folks can complain about the patch
> w/o understanding how SMBus block reads work, but are not willing to
> test it, something is wrong anyway.

I don't see York's posts as a complaint at all, just someone with a vested interest in this code trying to understand the patch.  I definitely appreciate the effort you have put into it already, and I'm disappointed that you think that this is now a waste of your time.

-- 
Timur Tabi
Linux kernel developer at Freescale

