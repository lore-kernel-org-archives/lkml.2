Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab0IRUEB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 16:04:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41351 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab0IRUD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 16:03:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :x-antivirus:x-antivirus-status;
        b=f1kVnHmMLSQQsNkF6RpyGzaZDjou4rndxKVamhFqp87KQCJo8JuwG15puUtTwQAW35
         ZOLa+6h0YX+2o83yI/IIjJcRj/1FU7xb8BosqEitedEeoK7AapvWnIeWW0dofAzM4Efy
         cc+DrgWAVbdhb75zqn8jJK3NiwEv3k5XquNRE=
Message-ID: <4C951B2A.1000706@gmail.com>
Date: Sat, 18 Sep 2010 13:03:54 -0700
From: Brian Norris <computersforpeace@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.9) Gecko/20100825 Thunderbird/3.1.3
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Sneha Narnakaje <nsnehaprabha@ti.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Kevin Cernekee <cernekee@gmail.com>
Subject: Re: [PATCH v4] mtd: nand: Expand nand_ecc_layout, deprecate ioctl
 ECCGETLAYOUT
References: <4C5CA4A1.1040000@broadcom.com>	 <1282154806-9420-1-git-send-email-norris@broadcom.com>	 <4C6DD170.1060807@renesas.com>  <4C6E9C23.6060703@broadcom.com>	 <1282646703.24044.162.camel@localhost>  <4C746DE0.7000104@gmail.com>	 <1283163647.12995.43.camel@brekeke> <1284830690.1721.3.camel@brekeke>
In-Reply-To: <1284830690.1721.3.camel@brekeke>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 100918-1, 09/18/2010), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/18/2010 10:24 AM, Artem Bityutskiy wrote:
> Brian,
> 
> would you address the small things I noticed in a follow-up patch?

Artem,

Yes, I will. I'm sorry for the delay; I've been a little busy and
putting some things off. Would you like a patch for the comments against
your l2 tree or try and squash it with my previous commit and base it
off of mtd-2.6 or some other option?

Brian
