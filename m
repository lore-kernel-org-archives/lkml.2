Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab1AYXQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 18:16:56 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48358 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753676Ab1AYXQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 18:16:54 -0500
X-Sasl-enc: FidmkbEKLuAbevrWjsrcyFncXZ0Vb8wJuUeKfXtoZdJg 1295997413
Date: Tue, 25 Jan 2011 21:16:51 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dominik Kopp <my@kabelfunk.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, platform-driver-x86@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        ibm-acpi-devel@lists.sourceforge.net
Subject: Re: [ibm-acpi-devel] thinkpad-acpi: fn-f4 issues
Message-ID: <20110125231651.GB25953@khazad-dum.debian.net>
References: <Pine.LNX.4.64.1101251740380.3737@boston.corp.fedex.com>
 <20110125151346.GB14803@khazad-dum.debian.net>
 <4D3F3AFF.7020407@kabelfunk.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D3F3AFF.7020407@kabelfunk.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jan 2011, Dominik Kopp wrote:
> I have also a X100e and the Fn-F4 (suspend-to-memory) and Fn-F12
> (suspend-to-disk) are not working. (no effect at all)

> [   15.362664] thinkpad_acpi: asked for hotkey mask 0x040988fc, but
> firmware forced it to 0x000988fc

The driver IS asking for Fn+F4 events.  Please send me the output of
acpidump, gzipped.

In the meanwhile, check if the input device is producing events when
you're pressing Fn+f4.  It could well be sending KEY_SUSPEND, but if
there's nobody listening...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
