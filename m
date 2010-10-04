Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab0JDNP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 09:15:58 -0400
Received: from smtp.tele.fi ([192.89.123.25]:47845 "EHLO
	vulpes-int.media.sonera.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755564Ab0JDNP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 09:15:57 -0400
X-Greylist: delayed 2855 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Oct 2010 09:15:57 EDT
X-Originating-Ip: [194.89.68.22]
Date: Mon, 4 Oct 2010 15:27:52 +0300
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: "Mr. Teo En Ming (Zhang Enming) ????????? of Singapore" 
	<space.time.universe@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "teoenming@hotmail.com" <teoenming@hotmail.com>,
        zhang_enming@lavabit.com
Subject: Re: Linux Kernel 2.6.36 Status
Message-ID: <20101004122752.GZ2804@reaktio.net>
References: <4C95BC88.9050301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C95BC88.9050301@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 19, 2010 at 03:32:24PM +0800, "Mr. Teo En Ming (Zhang Enming) ????????? of Singapore" wrote:
> Dear Linus Torvalds,
>
> May I know if Linux kernel 2.6.36 is Xen pv-ops dom0 ready?
>

Linux 2.6.36 will not contain pv-ops dom0 code. 

The RFC request about initial dom0 patches was sent recently, 
and once reviewd/ack'd, the code can go into later kernel version.

-- Pasi

> Thank you very much.
>
> -- 
> Yours sincerely,
>
> Mr. Teo En Ming (Zhang Enming) ????????? Dip(Mechatronics) BEng(Hons)(Mechanical Engineering)
> Citizenship: Singapore Citizen/Singaporean
> Alma Maters:
> [1] Singapore Polytechnic (Graduated 1998)
> [2] National University of Singapore (Graduated 2006)
> Facebook account: Teo En Ming (Zhang Enming)
> Facebook link: http://www.facebook.com/profile.php?id=100000750083982
> Facebook photos: http://www.facebook.com/profile.php?id=100000750083982#!/profile.php?id=100000750083982&v=photos
> Facebook videos: http://www.facebook.com/profile.php?id=100000750083982&v=app_2392950137
> Mobile Phone (Starhub pre-paid): +65-8369-2618
> Windows Live Messenger: teoenming-at-hotmail.com
> Location: Bedok Reservoir Road, Singapore
> ZIP: 470103
> My Open Letter (Plea for Medical Help/Assistance) to World Leaders (Updated 28 August 2010):-
> http://lists.mcs.anl.gov/pipermail/mpich-discuss/2010-August/007811.html
> http://mythtv.org/pipermail/mythtv-users/2010-August/295952.html
> http://archives.gentoo.org/gentoo-user/msg_f6a341d9623fda17880159b137c07335.xml
> Photo of Mr. Teo En Ming (Zhang Enming) ????????? of Singapore: http://i53.tinypic.com/207tamp.jpg
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
