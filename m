Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab1JQNb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 09:31:28 -0400
Received: from enyo.dsw2k3.info ([195.71.86.239]:45560 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892Ab1JQNbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 09:31:24 -0400
X-Greylist: delayed 474 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Oct 2011 09:31:24 EDT
Date: Mon, 17 Oct 2011 15:23:18 +0200
From: Matthias Schniedermeyer <ms@citd.de>
To: Charles Buysschaert <Charles.Buysschaert@intopix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Speed of RAM reserved with memmap kernel command line option.
Message-ID: <20111017132318.GA9098@citd.de>
References: <894F5F1132E3C5458AAB08FA0A1AC9380F1E2F12@IPX-MAIL.Intopix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <894F5F1132E3C5458AAB08FA0A1AC9380F1E2F12@IPX-MAIL.Intopix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.10.2011 07:51, Charles Buysschaert wrote:
> Hello all, 
> 
> We are writing a PCI-e "frame grabber-like" driver for linux 2.6 kernel.
...
> I guess cache is not used. Does anyone know if there is a way to speed this up? How could we set that area to "cached"? 

Smells to me like you are missing a mapping in MTRR ...
Documentation/x86/mtrr.txt

... or PAT.
Documentation/x86/pat.txt





Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

