Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab2KMCcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 21:32:12 -0500
Received: from relay1.sgi.com ([192.48.179.29]:58013 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247Ab2KMCcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 21:32:11 -0500
Date: Mon, 12 Nov 2012 20:32:07 -0600
From: Ben Myers <bpm@sgi.com>
To: Thiago Farina <tfransosi@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Alex Elder <elder@kernel.org>,
        linux list <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: xfs: Remove boolean_t typedef completely.
Message-ID: <20121113023207.GZ9783@sgi.com>
References: <CACnwZYd2kPaK1urLYc8BBuuqD7_Oo1oF+KvqWYj7DAEGy6grHQ@mail.gmail.com>
 <20121113015318.GD25039@dastard>
 <CACnwZYeutkdb+=yYx8XcXHSDhaP6QBjgn1BEnGAMYDO7biAtFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACnwZYeutkdb+=yYx8XcXHSDhaP6QBjgn1BEnGAMYDO7biAtFw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thiago,

On Tue, Nov 13, 2012 at 12:02:14AM -0200, Thiago Farina wrote:
> On Mon, Nov 12, 2012 at 11:53 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Mon, Nov 12, 2012 at 10:36:47PM -0200, Thiago Farina wrote:
> >> On Mon, Nov 12, 2012 at 10:24 PM, Dave Chinner <david@fromorbit.com> wrote:
> >> > On Mon, Nov 12, 2012 at 09:36:17PM -0200, Thiago Farina wrote:
> >> >> Hi,
> >> >>
> >> >> Please, take a look.
> >> >>
> >> >> Patch attached.
> >> >
> >> > It's a good start for a cleanup, but there's no point in removing
> >> > the boolean_t from one file and then not removing it from the rest
> >> > of the XFS code.  It's only used in a handful of places, so just
> >> > remove it completely.
> >> >
> >> Done.
> >>
> >> Please, take another look.
> >>
> >> > Also, can you please place patches in line rather than attaching
> >> > them. Attaching them means they cannot be quoted in reply. See
> >> > Documentation/SubmittingPatches and Documentation/email-clients.txt
> >> > for guidelines.
> >> >
> >> Sorry, patch attached.
> >
> > It's still attached as a base64 encoded attachment, not as inline
> > text....
> >
> Yep, sorry about that. Is just a text file from $(git format-patch master);

If you don't mind another try... it would be helpful if you could resend the
patch inline.  It helps to facilitate a discussion of the patch along with your
text should it be necessary.

You're only touching xfs, so you can drop linux-kernel if you want.

Thanks,
	Ben
