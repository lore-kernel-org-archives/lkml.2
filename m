Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab2FFOkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:40:21 -0400
Received: from static.121.164.40.188.clients.your-server.de ([188.40.164.121]:60741
	"EHLO smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab2FFOkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:40:20 -0400
Date: Wed, 6 Jun 2012 16:40:12 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1482118647.20120606164012@eikelenboom.it>
To: Kees Cook <keescook@chromium.org>
CC: "Ted Ts'o" <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>,
        <dm-devel@redhat.com>, <linux-ext4@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: EXT4-fs error (device dm-42): ext4_mb_generate_buddy:741: group 1904, 32254 clusters in bitmap, 32258 in gd
In-Reply-To: <CAGXu5jK-4dO59-x3eTU10OntcPwsVptjpUzQdbbHOvy9_VBQ2A@mail.gmail.com>
References: <471046920.20120604234941@eikelenboom.it> <20120605000356.GM29466@outflux.net> <1018371644.20120605224154@eikelenboom.it> <20120605210806.GB7182@thunk.org> <1883708187.20120606090126@eikelenboom.it> <CAGXu5jK-4dO59-x3eTU10OntcPwsVptjpUzQdbbHOvy9_VBQ2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Wednesday, June 6, 2012, 4:32:52 PM, you wrote:

> On Wed, Jun 6, 2012 at 12:01 AM, Sander Eikelenboom
> <linux@eikelenboom.it> wrote:
>> Another thing that thought of that could be of interest, i think this was a ext3 converted to ext4 partition.
>> Don't know if that is true for the other reports as well though.

> FWIW, in my case, I have just built a fresh ext4 and immediately copy
> data to it.

> -Kees



And it still results in the error ?
And if you use it without the uninit_bg feature by running:

tune2fs -O ^uninit_bg

Then fsck found errors in my case after fixing them, i could copy files normally.
Does that work in your case as well ?
--
Sander


