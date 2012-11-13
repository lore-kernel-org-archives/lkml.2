Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab2KMCCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 21:02:17 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38385 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab2KMCCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 21:02:16 -0500
MIME-Version: 1.0
In-Reply-To: <20121113015318.GD25039@dastard>
References: <CACnwZYd2kPaK1urLYc8BBuuqD7_Oo1oF+KvqWYj7DAEGy6grHQ@mail.gmail.com>
	<20121113015318.GD25039@dastard>
Date: Tue, 13 Nov 2012 00:02:14 -0200
Message-ID: <CACnwZYeutkdb+=yYx8XcXHSDhaP6QBjgn1BEnGAMYDO7biAtFw@mail.gmail.com>
Subject: Re: xfs: Remove boolean_t typedef completely.
From: Thiago Farina <tfransosi@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux list <linux-kernel@vger.kernel.org>, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>, xfs@oss.sgi.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 11:53 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Nov 12, 2012 at 10:36:47PM -0200, Thiago Farina wrote:
>> On Mon, Nov 12, 2012 at 10:24 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Mon, Nov 12, 2012 at 09:36:17PM -0200, Thiago Farina wrote:
>> >> Hi,
>> >>
>> >> Please, take a look.
>> >>
>> >> Patch attached.
>> >
>> > It's a good start for a cleanup, but there's no point in removing
>> > the boolean_t from one file and then not removing it from the rest
>> > of the XFS code.  It's only used in a handful of places, so just
>> > remove it completely.
>> >
>> Done.
>>
>> Please, take another look.
>>
>> > Also, can you please place patches in line rather than attaching
>> > them. Attaching them means they cannot be quoted in reply. See
>> > Documentation/SubmittingPatches and Documentation/email-clients.txt
>> > for guidelines.
>> >
>> Sorry, patch attached.
>
> It's still attached as a base64 encoded attachment, not as inline
> text....
>
Yep, sorry about that. Is just a text file from $(git format-patch master);
