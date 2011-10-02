Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab1JBSYg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 14:24:36 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:47285 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753772Ab1JBSYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 14:24:31 -0400
X-Sasl-enc: mhyD1uVI7KbhLyuX6Z6hjJjRZQusT8rfdtw2OTY39uxM 1317579871
Date: Sun, 2 Oct 2011 15:24:28 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: kernel.org status: establishing a PGP web of trust
Message-ID: <20111002182428.GC16368@khazad-dum.debian.net>
References: <4E8655CD.90107@zytor.com>
 <201110021354.57995.rjw@sisk.pl>
 <4E88A537.4010008@zytor.com>
 <201110022014.27549.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201110022014.27549.rjw@sisk.pl>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 02 Oct 2011, Rafael J. Wysocki wrote:
> Well, then I propose that people create two new key pairs instead of
> just one and take both of them to the KS for signing.  Afterwards, one
> of them will be used for development and the other one's private key
> will be kept in a safe place (without any online access), so it can be
> used readily if the first pair is lost or compromised somehow.
> 
> Perhaps the second pair should have a longer life time.

Maybe subkeys would be enough/better?

http://wiki.debian.org/subkeys

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
