Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760139Ab2EJPeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:34:08 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41678 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760008Ab2EJPeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:34:05 -0400
MIME-Version: 1.0
In-Reply-To: <20120510150353.GI23768@redhat.com>
References: <cover.1336619038.git.koverstreet@google.com>
	<20120510150353.GI23768@redhat.com>
Date: Thu, 10 May 2012 08:34:04 -0700
Message-ID: <CAH+dOxJuubWJ5cRa=Xb4SFuH8wvCaKsF-DfN8bDpQNOtB4_WCA@mail.gmail.com>
Subject: Re: [dm-devel] [Bcache v13 00/16]
From: Kent Overstreet <koverstreet@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tejun@google.com, agk@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 8:03 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, May 09, 2012 at 11:07:29PM -0400, Kent Overstreet wrote:
>
> [..]
>> The userspace interface is going to change before it goes in. The general
>> consensus at LSF was that we don't want yet another interface for
>> probing/managing block devices, and dm exists so we may as well use that. I
>> don't think anyone's started on that yet, though.
>>
>
> Ok, I missed above lines and was pointed to it. So idea of this posting is
> to review core changes and then somebody else needs to take the core, wrap
> it with dm apis and repost?

More or less - I'm not sure who's going to be doing the dm integration
work (I honestly don't have time), but it's not been forgotten. But
there's other stuff that needs review in the meantime.
