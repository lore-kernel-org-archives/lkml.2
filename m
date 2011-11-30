Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302Ab1K3LPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 06:15:15 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:44679 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753348Ab1K3LPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 06:15:12 -0500
X-Sasl-enc: 4d5g7Cd/4wxwzVI0Xo6HlokKebQZo3MCwUkBDe0nqkVj 1322651711
Date: Wed, 30 Nov 2011 09:15:07 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Natanji <natanji@gmail.com>
Cc: Henning Schild <henning@wh9.tu-dresden.de>, Tom Gundersen <teg@jklm.no>,
        ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, maciej.rutecki@gmail.com, lenb@kernel.org
Subject: Re: [ibm-acpi-devel] Regression in thinkpad-acpi events
Message-ID: <20111130111507.GA32079@khazad-dum.debian.net>
References: <4EBAC3B5.5060405@gmail.com>
 <201111142031.06663.maciej.rutecki@gmail.com>
 <4EC16F8E.7060601@gmail.com>
 <201111142118.47256.maciej.rutecki@gmail.com>
 <CAG-2HqVnsmSyHVCvEVf+sZw5NxhR8qSDDB0AtR+igwCCFiwfgQ@mail.gmail.com>
 <20111115230305.GA23325@khazad-dum.debian.net>
 <20111127022346.32f11849@schlepp.lan>
 <4ED5F5D7.8020208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED5F5D7.8020208@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Nov 2011, Natanji wrote:
> The standard Arch kernel does not use tuxonice, you need to build your
> kernel manually if you want it. I also don't receive these events before
> the first hibernation, so you might be having a different problem.

Just a hunch: check /proc/interrupts.  One of them must be assigned to acpi,
and it *must* increase when you press hotkeys, etc.

Does it?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
