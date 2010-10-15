Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478Ab0JOTxe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 15:53:34 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33048 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932457Ab0JOTxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 15:53:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=bQdUDIWAIEIlyQhwmwC9YP088ZYj9GzXDub/mJBqrhNSA7PDvqNvm+X83GTxoRJ+c4
         li8RZj6gHobxgLkXczqP8YQBnKPt8idH6cbNC19iT93Ez8b5cZDJZkVFKKORvqUqjgi9
         1VBQKfAdVbaJe8BYPSPNTL6reQdCNxDc/9qUs=
MIME-Version: 1.0
In-Reply-To: <20101015192029.GA28742@kroah.com>
References: <E9954878DD1FB34FAE5187FB88C58A35012EE46BC3@orsmsx506.amr.corp.intel.com>
 <AANLkTi=6aVHyr98avc07UtWgDkV=SdmKW2HXNfSRY3KU@mail.gmail.com> <20101015192029.GA28742@kroah.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 15 Oct 2010 12:53:10 -0700
Message-ID: <AANLkTim-=W7sBrkqvRWfzaQ7FmzCXSSn57N3biDKi2WU@mail.gmail.com>
Subject: Re: compat-wireless question
To: Greg KH <greg@kroah.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>
Cc: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 12:20 PM, Greg KH <greg@kroah.com> wrote:
> On Fri, Oct 15, 2010 at 12:05:00PM -0700, Luis R. Rodriguez wrote:
>> Furthermore, I realize that at times a vendor may have a patch that
>> although it did not make it into the stable release of the kernel it
>> may be important for the vendor for some customers, so because of this
>> we have the linux-next-cherry-picks/ directory.
>
> I'd be interested in taking these patches for -stable releases, if they
> are in Linus's tree already, so feel free to forward them on to
> stable@kernel.org if you get them.

Oh sweet, thanks, will do!!! We have one for sure coming up soon, will
be sure to Cc stable for it.

  Luis
