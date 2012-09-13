Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab2IMAaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:30:18 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:45928 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365Ab2IMAaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 20:30:11 -0400
Message-ID: <5051290E.1000001@gmail.com>
Date: Thu, 13 Sep 2012 10:30:06 +1000
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Rich Lawlman <richlawlman@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Various things Linux doesn't have/doesn't need
References: <CAOqfy0W67ZZ59+jUjEG8dLc9BSyqnYnnP+TpB7kz6VJVnYchsA@mail.gmail.com>
In-Reply-To: <CAOqfy0W67ZZ59+jUjEG8dLc9BSyqnYnnP+TpB7kz6VJVnYchsA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/09/12 10:18, Rich Lawlman wrote:
> It is by fine, unbiased analysis I propose the following:
>
>    For one, drop all support for cpu archs except ARM. Dropping support
> will reduce development strain, and x86 has no foreseeable future
> anyways. This will allow Linux to accelerate its development pace on
> the one thing it currently has potential in; low-powered devices such
> as mobile/embedded, as Linux on the desk is a virtual wasteland.
>
>    In addition, no one cares about the true state or existence of their
> files, and the assumption they do is why Linux scares new guys and the
> iPhone became popular. The kernel should instead make the filesystem
> "invisible" to the user; by default making only user files visible
> from a file manager and making only files related to a particular app
> available in that app. More secure, more simple, easier for the
> simpleton.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


I'm sorry, I have to ask this.

Do you guys get paid (or are part of a bet) when you make
suggestions like these, or do you just do it for, as a friend
tells me, "shits and giggles"?

OT: Or rename x86 to LEG, and watch all the others turn into
EYE and BodyFS, etc. ...Nope, still doesn't make sense,
but at least it doesn't sound too crazy. Just a bit whacko :)
