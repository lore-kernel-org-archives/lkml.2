Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab2HVGRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 02:17:55 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:59075 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab2HVGRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 02:17:54 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Al Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH 0/4] fat: fix ESTALE errors
References: <1345282899-7534-1-git-send-email-linkinjeon@gmail.com>
	<20120818132524.GW23464@ZenIV.linux.org.uk>
	<87pq6op9zz.fsf@devron.myhome.or.jp>
	<CAKYAXd_VyRg5PYjcYb_JtDeXHeMSRtwwT665hcMcf4WCer7a_Q@mail.gmail.com>
	<20120820205231.GG5779@fieldses.org>
	<CAKYAXd8fkV5x454vtXvwM6LN3Hb2dLgemhJdNFKyxnwweNq75A@mail.gmail.com>
	<874nnwiw67.fsf@devron.myhome.or.jp>
	<CAE2SPAan64zL2Fy3VDHetewHbV71cuHhkEd3AoTJEzeBG=FyEA@mail.gmail.com>
	<87628bjvwb.fsf@devron.myhome.or.jp>
Date: Wed, 22 Aug 2012 15:17:52 +0900
In-Reply-To: <87628bjvwb.fsf@devron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Wed, 22 Aug 2012 15:14:28 +0900")
Message-ID: <87y5l7ih67.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:

>> I mean using a special value for this case, mark delete (using 0xe5 as
>> first character) but put for instance creation month to be egal to 15.
>>
>> This entry will be therefore be keep and not overwritten by successive
>> file creation.
>>
>> At least this solve the file deleted issue (not the rename issue unfortunatly)
>
> I assume you are saying to prevent creation somehow, not deletion. Yes, it
> is possible though, it would give additional overhead and complexity to us.

In short, it meant I think it is not so simple to do it.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
