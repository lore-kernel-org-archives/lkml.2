Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751055Ab0J3EfL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 00:35:11 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36293 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab0J3EfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 00:35:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kXVPhwcQOo7Ai6JsbfFkaOA6OUGJ+wvsb+SZhkA4MyCEnpTw4dH31QpApVjsXqFPLe
         yfP23LQ8ZJ/fGNYqjffqZQmRpPtI13TDAGkPcRlV2NlLCcYQfR/0rNvhc7k5tn2YPyV1
         jnCRQgiQq+NUhSYdg+sqzmnQ1kLCkK9hAozWU=
Message-ID: <4CCBA075.2030204@gmail.com>
Date: Sat, 30 Oct 2010 12:35:01 +0800
From: =?UTF-8?B?IlNpbmdhcG9yZSBDaXRpemVuIE1yLiBUZW8gRW4gTWluZyAoWmhhbmcgRQ==?=
	 =?UTF-8?B?bm1pbmcpIOW8oOaBqem4oyAi?= 
	<space.time.universe@gmail.com>
Reply-To: space.time.universe@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: "space.time.universe@gmail.com" <space.time.universe@gmail.com>,
        "teoenming@hotmail.com" <teoenming@hotmail.com>,
        zhang_enming@lavabit.com
Subject: Re: [KORG] Master / hera upgrade & downtime announcement
References: <4CCB3158.9010406@kernel.org>
In-Reply-To: <4CCB3158.9010406@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2010 04:40 AM, J.H. wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Afternoon Everyone,
>
> Thought I'd give everyone a quick heads up, that since Kernel Summit
> starts on the 1st of November, which means I've got my one chance to do
> system maintenance on master / hera for the year.
>
> I'm expecting to do the upgrade on the 1st itself, likely start time
> will be around Mon Nov  1 19:00:00 UTC 2010, and I'm hoping for the
> entire downtime to take no longer than 2 hours.
>
> Things that are going to happen during the upgrade:
>
> 	- OS getting upgraded to Fedora 13
> 		w/ custom kernel to solve XFS and disable IMA
> 	- Hardware change
> 		Google and HP have been very generous enough to
> 		get us a new machine for the master / hera machine.
> 		The new machine is a dual, quad core Xeon X5550 box
> 		with 32G of ram.  Beyond that it nearly identical to the
> 		current machine.
>
> 		The current machine will become a 'live' backup machine
> 		that will sync semi-continuously, and be available
> 		should catastrophic failure of master / hera occur.
>
> Think that's the main big changes.  I'm already working on the upgrade
> since I have multiple boxes to do this with, and things are looking good
> so far.
>
> As a note the start time is estimated, if there is a major change to the
> start time I will let everyone know.
>
> As always, if you have questions, comments or concerns please e-mail me
> or ftpadmin@kernel.org
>
> - - John 'Warthog9' Hawley
> Chief Kernel.org Administrator
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.10 (GNU/Linux)
> Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/
>
> iEYEARECAAYFAkzLMVgACgkQ/E3kyWU9did9wACeO0nlEtiX52u6pD3slKtqZ61M
> ZTgAn3TLwks7sT5ovpf9X6/WSbK7+hcz
> =gIkm
> -----END PGP SIGNATURE-----
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>    

Noted with thanks.

-- 
Yours sincerely,

Singapore Citizen Mr. Teo En Ming (Zhang Enming) 张恩鸣 Dip(Mechatronics) BEng(Hons)(Mechanical Engineering)
Singapore Identity Card No.: S78*6*2*H
Location: Bedok Reservoir Road, Singapore
ZIP: 470103
Mobile Phone (Starhub Pre-paid): +65-8369-2618
Windows Live Messenger: teoenming-at-hotmail.com
My Youtube videos: http://www.youtube.com/user/enmingteo
Alma Maters:
[1] Singapore Polytechnic (Graduated 1998)
[2] National University of Singapore (Graduated 2006)
My Open Letter (Plea for Medical Help/Assistance) to World Leaders (Updated 28 August 2010):-
http://lists.mcs.anl.gov/pipermail/mpich-discuss/2010-August/007811.html
http://mythtv.org/pipermail/mythtv-users/2010-August/295952.html
http://archives.gentoo.org/gentoo-user/msg_f6a341d9623fda17880159b137c07335.xml
Photograph of Singapore Citizen Mr. Teo En Ming (Zhang Enming) 张恩鸣 #1:
http://i.imgur.com/M1FNX.jpg
Photograph of Singapore Citizen Mr. Teo En Ming (Zhang Enming) 张恩鸣 #2:
http://i51.tinypic.com/11u9irm.jpg
Photograph of Singapore Citizen Mr. Teo En Ming (Zhang Enming) 张恩鸣 #3:
http://www.imagevimage.com/images/Singapore_Citizen_Mr._Teo_En_Ming_%28Zhang_Enming%29.jpg
Photograph of Singapore Citizen Mr. Teo En Ming (Zhang Enming) 张恩鸣 #4:
http://www.merrypic.com/files/o397beqo7qw8wky5rjno.jpg
Photograph of Singapore Citizen Mr. Teo En Ming (Zhang Enming) 张恩鸣 #5:
http://piczasso.com/i/yicuz.jpg
Photograph of Singapore Citizen Mr. Teo En Ming (Zhang Enming) 张恩鸣 #6:
http://www.freeimagehosting.net/uploads/1b553b21ae.jpg

