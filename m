Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab0L0Ogw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 09:36:52 -0500
Received: from 63.mail-out.ovh.net ([91.121.185.56]:34655 "HELO
	63.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753779Ab0L0Ogv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 09:36:51 -0500
Message-ID: <4D18A480.2060309@example.com>
Date: Mon, 27 Dec 2010 15:36:48 +0100
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101211 Icedove/3.0.11
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 27
References: <20101227170451.a9a9f873.sfr@canb.auug.org.au>
In-Reply-To: <20101227170451.a9a9f873.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 11853474219501384154
X-Ovh-Remote: 79.185.217.224 (adtf224.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.12.2010 07:04, Stephen Rothwell wrote:

Hello,

I noticed that after first reboot with this kernel that my MP3 
collection in mocp layed on Ext4 fs opens painfully slow. It is not my 
mistake, because I always do it the same way, new kernel, then music on. 
The problem is not present in rc7-git4. I could measure it in some way 
(timing ls -la in tht dir?) if somebody needs it.

Regards,

Piotr Hosowicz

-- 
Demokracja to kult szakali wyznawany przez os³y (Henry Louis Mencken)
NP: Peter Green Splinter Group - Big Change Is Gonna Come
NB: 2.6.37-rc7-next-20101227
