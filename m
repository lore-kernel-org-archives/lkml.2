Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab2EZAa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 20:30:57 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36715 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab2EZAa4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 20:30:56 -0400
MIME-Version: 1.0
In-Reply-To: <1337992009.23813.YahooMailClassic@web84502.mail.ne1.yahoo.com>
References: <1337992009.23813.YahooMailClassic@web84502.mail.ne1.yahoo.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 25 May 2012 17:30:34 -0700
X-Google-Sender-Auth: q8yYFffbmvVdgLSbH8gJlxBrIJs
Message-ID: <CA+55aFy7tji1bU8rT2CC2nc9wfqk_5S8R53Js2=e6k1soGSFtQ@mail.gmail.com>
Subject: Re: Regression Mounting /proc w/ kernel 3.4.0 - "uid" parameter no
 longer ignored.
To: kd6lvw@yahoo.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Vasiliy Kulikov <segoon@openwall.com>,
        Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 5:26 PM,  <kd6lvw@yahoo.com> wrote:
>
> I personally don't care if the option is restored or not.  My issue was that this side effect was not documented in any way in the change that occurred -- which affected documented behavior.

Umm. The side effect wasn't documented, because nobody even *thought* of it.

If people had thought of it, it wouldn't have happened. So harping
about documentation is kind of pointless.

The real question is whether there might be some other option
(documented or not) that people might have used and just accidentally
relied on the fact that /proc never even bothered to look at them.

                      Linus
