Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab1LRPTe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 10:19:34 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:33143 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751670Ab1LRPTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 10:19:32 -0500
X-Sasl-enc: ZJWFGOZ7TYrUo9nHVltyoxplp89u0sJUcl5+p86OKXA1 1324221571
Subject: Re: chroot(2) and bind mounts as non-root
From: Colin Walters <walters@verbum.org>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>, serue@us.ibm.com,
        dhowells@redhat.com, kzak@redhat.com
Date: Sun, 18 Dec 2011 10:19:12 -0500
In-Reply-To: <CALQRfL4_zWAp3ZUM2GXKaw_6ofEfLUGs9WypD9qi_-15MeQx0Q@mail.gmail.com>
References: <1323280461.10724.13.camel@lenny> <4EDFCDD4.2080603@zytor.com>
	 <20111207205459.031a0609@lxorguk.ukuu.org.uk>
	 <CALQRfL6A+XUiLUVzsSOkz52rs7Pejtb_v8QZbpWxh5W8yYDYtg@mail.gmail.com>
	 <1324050284.3734.14.camel@lenny>
	 <CALQRfL4_zWAp3ZUM2GXKaw_6ofEfLUGs9WypD9qi_-15MeQx0Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1324221552.21713.7.camel@lenny>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-12-17 at 17:22 -0800, Andrew G. Morgan wrote:

> I don't read any issues with this in your original post. What I read
> there is that you want to run a build in a chroot environment. Are you
> also implying that the user gets to build this chroot filesystem from
> nothing - without any privileges - 

Yes.  The filesystem is owned by the user.  

> If the former, then yes I think you are going to have a very hard
> time.

Well, it already works with the setuid program I attached earlier.
So...what are we trying to accomplish in this discussion? 

If you think there's a way to allow users to chroot *without* cutting
off setuid binaries, I am definitely interested in that.  However I'm
very, very skeptical.


