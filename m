Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759009Ab2JKR7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 13:59:40 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:58609 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706Ab2JKR7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 13:59:38 -0400
Message-ID: <50770905.5070904@suse.cz>
Date: Thu, 11 Oct 2012 19:59:33 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0a2
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Jiri Slaby <jirislaby@gmail.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: kswapd0: wxcessive CPU usage
References: <507688CC.9000104@suse.cz> <106695.1349963080@turing-police.cc.vt.edu>            <5076E700.2030909@suse.cz> <118079.1349978211@turing-police.cc.vt.edu>
In-Reply-To: <118079.1349978211@turing-police.cc.vt.edu>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2012 07:56 PM, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 11 Oct 2012 17:34:24 +0200, Jiri Slaby said:
>> On 10/11/2012 03:44 PM, Valdis.Kletnieks@vt.edu wrote:
>>> So at least we know we're not hallucinating. :)
>> 
>> Just a thought? Do you have raid?
> 
> Nope, just a 160G laptop spinning hard drive. Filesystems are ext4
> on LVM on a cryptoLUKS partition on /dev/sda2.

Ok, it's maybe compaction. Do you have CONFIG_COMPACTION=y?


-- 
js
suse labs
