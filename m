Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab2DAH1B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 03:27:01 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:46276 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab2DAH1A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 03:27:00 -0400
MIME-Version: 1.0
In-Reply-To: <20120331201825.036fe1d8@corrin.poochiereds.net>
References: <20120330195801.GA31806@kroah.com>
	<20120330194846.517484801@linuxfoundation.org>
	<20120331201825.036fe1d8@corrin.poochiereds.net>
Date: Sun, 1 Apr 2012 02:26:58 -0500
Message-ID: <CAH2r5muM-4_pVt59XeNrOZZ=28P0hT8GiMqBUk+0nxnUw9L+VA@mail.gmail.com>
Subject: Re: [ 105/175] CIFS: Respect negotiated MaxMpxCount
From: Steve French <smfrench@gmail.com>
To: Jeff Layton <jlayton@samba.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Pavel Shilovsky <piastry@etersoft.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 7:18 PM, Jeff Layton <jlayton@samba.org> wrote:
> On Fri, 30 Mar 2012 12:50:10 -0700
> Greg KH <gregkh@linuxfoundation.org> wrote:
>
>> 3.3-stable review patch.  If anyone has any objections, please let me know.
>>
>
> I'm not sure it's a good idea to put this patch into any stable release
> just yet. I think it's a correct and necessary fix, but it has some
> potential to cause regressions too (or uncover other preexisting
> problems with this code). Might it be best to wait until we have some
> more experience with this before we push it into stable?

Delaying it a little is probably ok, but weigh that against the
frequency/severity
of the problem that Pavel's fix addresses:  ie sequential writes to some
versions of Windows 7 and Windows Vista can fail partway
through large file copy (which also causes those servers
to become unresponsive to subsequent connection requests
as well) so the fix does address a hot problem.



-- 
Thanks,

Steve
