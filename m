Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608Ab0FOSqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 14:46:46 -0400
Received: from lirone.symas.net ([64.71.152.235]:39346 "EHLO lirone.symas.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758604Ab0FOSqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 14:46:43 -0400
Message-ID: <4C17CA8A.1060406@symas.com>
Date: Tue, 15 Jun 2010 11:46:34 -0700
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; rv:1.9.3a5pre) Gecko/20100607 Firefox 3.6
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 0/2] tty: add EXTPROC support for LINEMODE
References: <4C120D8A.8050207@symas.com> <87631pq2aj.fsf@basil.nowhere.org> <4C121B4C.2000702@symas.com> <4C12E4B7.4020900@symas.com> <4C17C190.1020000@symas.com> <20100615183501.GA22092@kroah.com>
In-Reply-To: <20100615183501.GA22092@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Jun 15, 2010 at 11:08:16AM -0700, Howard Chu wrote:
>> Paraphrased from the 1989 BSD patch by David Borman @ cray.com:
>
> <snip>
>
> This is the stuff you need in the 1/2 patch, otherwise it will be lost.
>
> Does the build break if you don't apply the second patch?  Or is that
> just needed to hook everything up for all of the arches?  We can't break
> things inbetween each patch.
>
> Care to resend?

Yeah, since it's not ifdef'd I imagine it will break all of the other arches 
if applied separately.

And it looks like my mail client butchered the patches so I was going to have 
to resend anyway. Coming up...
-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
