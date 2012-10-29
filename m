Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368Ab2J2OmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 10:42:04 -0400
Received: from antcom.de ([188.40.178.216]:59869 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759311Ab2J2Ol7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 10:41:59 -0400
Message-ID: <508E95B3.7070807@antcom.de>
Date: Mon, 29 Oct 2012 15:41:55 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.9) Gecko/20121015 Icedove/10.0.9
MIME-Version: 1.0
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: 3.7-rc3 oops on reboot
References: <CAAAP30E-g3YdXOMvfueDQZREZ+_Adi2uhxgLeqKixkupU+QNhA@mail.gmail.com> <508E7B47.60207@antcom.de> <CAAAP30HWhz_h4AVwjkw9APw6pv0ydO=GZ89uaBhKbmjw60ym4Q@mail.gmail.com>
In-Reply-To: <CAAAP30HWhz_h4AVwjkw9APw6pv0ydO=GZ89uaBhKbmjw60ym4Q@mail.gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2012 02:51 PM, Alexandre Pereira da Silva wrote:
>> I just tried both on a PHY3250 reference machine, and on a custom board
>> and couldn't reproduce sth. like this. Booted the kernel and connected
>> the ethernet cable later on, as well as with cable connected on boot.
> 
> This is happening on my custom board. I didn't try this on the
> reference board yet.
> 
>> Any related patches applied? Can you reproduce this on a reference
>> machine? Can you provide a .config for this? Any more detail about how
>> this could be reproduced?
> 
> No patches applied. I'm trying to bisect this. This happens on a clean
> -rc1 as well. Doesn't happen on v3.6.
> 
> Attached my .config
> 
> To reproduce this, I am just running "reboot". I have the ethernet
> cable always connected here.

Just tried this with your .config on the PHY3250 (w/o your initrd
thought) but couldn't reproduce the issue.

Maybe it's related to your Micrel ethernet PHY (activated in your
config) which I don't have hardware for?

Otherwise, we would need to have a look at your devicetree.

Roland
