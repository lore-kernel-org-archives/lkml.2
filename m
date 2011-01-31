Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab1AaIwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 03:52:22 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:1261 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755253Ab1AaIwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 03:52:20 -0500
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
To: "Greg KH" <greg@kroah.com>, "Stephen Rothwell" <sfr@canb.auug.org.au>
cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the staging tree with the
 staging.current tree
References: <20110131160926.27223d25.sfr@canb.auug.org.au>
Date: Mon, 31 Jan 2011 09:52:03 +0100
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Organization: Broadcom
Message-ID: <op.vp5z8zyj3ri7v4@arend-laptop>
In-Reply-To: <20110131160926.27223d25.sfr@canb.auug.org.au>
User-Agent: Opera Mail/11.01 (Linux)
X-WSS-ID: 6158A7163H012017155-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, 31 Jan 2011 06:09:26 +0100, Stephen Rothwell  
<sfr@canb.auug.org.au> wrote:

> Hi Greg,
>
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/brcm80211/brcmsmac/wl_mac80211.c,
> drivers/staging/brcm80211/sys/wlc_mac80211.c and
> drivers/staging/brcm80211/sys/wlc_mac80211.c (these three files names are
> the same file, it has been renamed twice, I think ..) between

wl_mac80211.c and wlc_mac80211.c are different source files. The driver  
source
tree has been restructured in the staging-next branch and files that were
located in brcm80211/sys are moved to brcm80211/brcmsmac.

>
> I fixed it up (see below) and can carry the fix as necessary.

The fix looks ok and I also verified the wl_mac80211.c in linux-next on
gitweb.

Regards,
Arend van Spriel
-- 
"The most merciful thing in the world, I think, is the inability of the  
human
mind to correlate all its contents." - "The Call of Cthulhu"

