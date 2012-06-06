Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab2FFOc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:32:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54988 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537Ab2FFOcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:32:53 -0400
MIME-Version: 1.0
In-Reply-To: <1883708187.20120606090126@eikelenboom.it>
References: <471046920.20120604234941@eikelenboom.it>
	<20120605000356.GM29466@outflux.net>
	<1018371644.20120605224154@eikelenboom.it>
	<20120605210806.GB7182@thunk.org>
	<1883708187.20120606090126@eikelenboom.it>
Date: Wed, 6 Jun 2012 07:32:52 -0700
X-Google-Sender-Auth: llnV4JsxEOaW2gauJHa16_it6Yg
Message-ID: <CAGXu5jK-4dO59-x3eTU10OntcPwsVptjpUzQdbbHOvy9_VBQ2A@mail.gmail.com>
Subject: Re: EXT4-fs error (device dm-42): ext4_mb_generate_buddy:741: group
 1904, 32254 clusters in bitmap, 32258 in gd
From: Kees Cook <keescook@chromium.org>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: "Ted Ts'o" <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>,
        dm-devel@redhat.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 12:01 AM, Sander Eikelenboom
<linux@eikelenboom.it> wrote:
> Another thing that thought of that could be of interest, i think this was a ext3 converted to ext4 partition.
> Don't know if that is true for the other reports as well though.

FWIW, in my case, I have just built a fresh ext4 and immediately copy
data to it.

-Kees

-- 
Kees Cook
Chrome OS Security
