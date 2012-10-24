Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab2JXLsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 07:48:17 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38322 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab2JXLsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 07:48:15 -0400
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Andreas Larsson <andreas@gaisler.com>
Cc: linux-i2c@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, software@gaisler.com
Subject: Re: [PATCH 2/2] i2c: i2c-ocores: Add support for the GRLIB port of the controller and custom getreg and setreg functions
References: <1351004637-11049-1-git-send-email-andreas@gaisler.com>
	<1351004637-11049-3-git-send-email-andreas@gaisler.com>
	<87sj95lywu.fsf@macbook.be.48ers.dk> <5087AF46.1070707@gaisler.com>
Date: Wed, 24 Oct 2012 13:48:04 +0200
In-Reply-To: <5087AF46.1070707@gaisler.com> (Andreas Larsson's message of
	"Wed, 24 Oct 2012 11:05:10 +0200")
Message-ID: <87bofsm6q3.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Andreas" == Andreas Larsson <andreas@gaisler.com> writes:

 >> Are all platforms using i2c-ocores guaranteed to provide ioread32be /
 >> iowrite32be or should we stick an #ifdef CONFIG_SPARC around it?

 Andreas> As far as I can see, after digging around, the only platforms that
 Andreas> have ioread/write32, but not ioread/write32be are frv and mn10300. Do
 Andreas> you know if those platforms are using i2c-ocores?

Not to my knowledge, no. In that case:

Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

-- 
Bye, Peter Korsgaard
