Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab1HRKKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 06:10:44 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:35639 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406Ab1HRKKk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 06:10:40 -0400
MIME-Version: 1.0
In-Reply-To: <20110815183358.GA31530@merkur.ravnborg.org>
References: <20110815160440.6296.95762.stgit@mj>
	<20110815183358.GA31530@merkur.ravnborg.org>
Date: Thu, 18 Aug 2011 18:10:40 +0800
Message-ID: <CAM_iQpVYiKYkNFLfL3r5S4PLKZsH2g=0rra-sxuQXSz+34CEag@mail.gmail.com>
Subject: Re: [PATCH] sparse: always enable endian checks
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Pavel Roskin <proski@gnu.org>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 2:33 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Mon, Aug 15, 2011 at 12:04:41PM -0400, Pavel Roskin wrote:
>> Checks enabled by __CHECK_ENDIAN__ produce less than a half of the
>> sparse warnings.  For instance, the allyesconfig configuration on
>> linux-next (tag next-20110812) produces on x86_64:
>>
>>                  no __CHECK_ENDIAN__   with __CHECK_ENDIAN__
>> stderr bytes:    1155037               1992954 (73% increase)
>> stderr lines:    10716                 18657   (74% increase)
>> affected files:  1191                  1458    (22% increase)
>>
>> It is no longer true that __CHECK_ENDIAN__ produces so many warnings
>> that other sparse warnings drown in the noise.
>>
>> Janitors going through the whole tree are already prepared to search for
>> the warnings they want to fix.
>>
>> The main point of this patch is to make sure that developers of a
>> particular driver who use sparse rarely get all the warnings for their
>> code even if they forget to specify __CHECK_ENDIAN__ or mistype it.
>>
>> Some developers actually added __CHECK_ENDIAN__ to the driver makefiles
>> so they don't forget to use it.  Remove them now.
>>
>> Remove all references to __CHECK_ENDIAN__ from the documentation except
>> the Chinese version, which would need to be updated separately.
>>
>> Signed-off-by: Pavel Roskin <proski@gnu.org>
> Acked-by: Sam Ravnborg <sam@ravnborg.org>
>
> Maybe ask Michal to merge it?
>

ping Michal... :)
