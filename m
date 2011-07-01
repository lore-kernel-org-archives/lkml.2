Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398Ab1GAM7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 08:59:19 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:41912 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756344Ab1GAM7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 08:59:18 -0400
Message-ID: <4E0DC4F3.6010203@free.fr>
Date: Fri, 01 Jul 2011 15:00:35 +0200
From: Bernard F6BVP <f6bvp@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110621 Mandriva/3.1.11-0.1mdv2010.2 (2010.2) Thunderbird/3.1.11
MIME-Version: 1.0
To: Ralf Baechle DL5RB <ralf@linux-mips.org>
CC: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Linux Netdev List <netdev@vger.kernel.org>, linux-hams@vger.kernel.org
Subject: Re: [AX25] inconsistent lock state
References: <4B2CD772.1030106@upmc.fr> <201106171536.15660.arnd@arndb.de> <20110617135147.GA3470@linux-mips.org> <201106171611.10655.arnd@arndb.de> <4E06040B.7040309@free.fr> <20110625163942.GB20976@linux-mips.org>
In-Reply-To: <20110625163942.GB20976@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Now, who is going to commit this mkiss patch and the equivalent one for 
sixpack.c ?

Bernard, f6bvp


Le 25/06/2011 18:39, Ralf Baechle DL5RB a écrit :
> On Sat, Jun 25, 2011 at 05:51:39PM +0200, f6bvp wrote:
>
>> I applied the patch and since then I could not reproduce the
>> inconsistent lock state.
>> Thus mkiss patch fixed it.
>
> I also think the patch is the right thing, so
>
> Acked-by: Ralf Baechle<ralf@linux-mips.org>
>
>    Ralf
