Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951Ab1JZMqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 08:46:18 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54264 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932898Ab1JZMqR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 08:46:17 -0400
MIME-Version: 1.0
In-Reply-To: <878vo8pj4h.fsf@rustcorp.com.au>
References: <87mxcppwg0.fsf@rustcorp.com.au> <CA+55aFyU=GxX+=b=Q2OP3BJNQuth7GWuAv5Zd63n209EJ0VOyw@mail.gmail.com>
 <878vo8pj4h.fsf@rustcorp.com.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 26 Oct 2011 14:45:48 +0200
X-Google-Sender-Auth: Qgz8wnd684tZpasYDbioNKO1cWo
Message-ID: <CA+55aFy_H1yjEhSXuztx2viYozVGLYrs=zEY-Ka9+1rPBrVPEA@mail.gmail.com>
Subject: Re: [PULL] module and param
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, Michal Schmidt <mschmidt@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 4:43 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>  + 694136c...b1e4d20 master -> master (forced update)
>  * [new tag]         rusty@rustcorp.com.au-v3.1-2-gb1e4d20 -> rusty@rustcorp.com.au-v3.1-2-gb1e4d20

That tag doesn't have any signature on it at all, it's just a plain
unsigned tag (ie just points to the commit) and thus useless.

Oh well. The commits look fine, but it would be much more convenient
if I could just trust the source.

          Linus
