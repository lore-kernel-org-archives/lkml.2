Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879Ab0ENHhQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 03:37:16 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:34653 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757443Ab0ENHhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 03:37:14 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: Re: render error detected, EIR: 0x00000010
Date: Fri, 14 May 2010 09:36:56 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-0.1-default; KDE/4.3.5; x86_64; ; )
Cc: Chris Wilson <chris@chris-wilson.co.uk>, dri-devel@lists.freedesktop.org,
       Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <AANLkTikfzHWeVjto4Q8bWDie_5BjRz3V0fc3LW7k4uob@mail.gmail.com> <201005140848.17512.oliver@neukum.org> <AANLkTinXjR1JVtaSL_1FKnAIuq0WX4rz4KoStuYRSME5@mail.gmail.com>
In-Reply-To: <AANLkTinXjR1JVtaSL_1FKnAIuq0WX4rz4KoStuYRSME5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005140936.56439.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 14. Mai 2010 09:27:24 schrieb Jaswinder Singh Rajput:
> Hello Oliver,
> 
> On Fri, May 14, 2010 at 12:18 PM, Oliver Neukum <oliver@neukum.org> wrote:
> > Am Freitag, 14. Mai 2010 00:29:08 schrieb Jaswinder Singh Rajput:
> >> Hello Chris,
> >>
> >> I am also getting display error on another PC :
> >>
> >> [   34.198957] render error detected, EIR: 0x00000010
> >> [   34.198972] [drm:i915_handle_error] *ERROR* EIR stuck: 0x00000010, masking
> >> [   34.198998] render error detected, EIR: 0x00000010
> >
> > Can you try using Xvideo and OpenGL at the same time?
> >
> 
> Can you please let me know how can I do so. Can you tell me some test
> procedure. I have Fedora 10 on this PC.

"glxgears" and viewing a video at the same time should do it.

	Regards
		Oliver
