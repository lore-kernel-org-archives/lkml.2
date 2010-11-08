Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab0KHL0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 06:26:48 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33723 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab0KHL0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 06:26:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=MfhiGfpZjanu9zI5JouoQpaTmiYwtiNuM5VFuIvoBBRze2xuJ0ypa4mA6IXPfpqz8O
         JSuipKUU+Zo2YaFirNdbOJlwa5qXg6yylrITzYcow5CtLbo+1caQ1HQnby0KBbTAT4J6
         lAPHzjigMp0DVd/zOq1Rn/GjCPY8Fl/lEGUgA=
MIME-Version: 1.0
In-Reply-To: <b9dded$h0q3am@orsmga002.jf.intel.com>
References: <1289211512.3916.383.camel@constitution.bos.jonmasters.org>
	<b9dded$h0q3am@orsmga002.jf.intel.com>
Date: Mon, 8 Nov 2010 11:26:46 +0000
Message-ID: <AANLkTimXxYw7WLr3SKQxX5-Tadt0EJTQQSbKsqsLJNiL@mail.gmail.com>
Subject: Re: [bisected] offset display bug in i915
From: James Courtier-Dutton <james.dutton@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jon Masters <jonathan@jonmasters.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 November 2010 10:27, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Mon, 08 Nov 2010 05:18:32 -0500, Jon Masters <jonathan@jonmasters.org> wrote:
>> Hi Chris,
>>
>> The following patch that you recently committed breaks my ASUS Eee PC
>> 1015PEM by causing the display to be offset by about 1 inch (a few
>> centimeters) when the mode is (re)set during boot. I previously posted
>> both photographs and video of the problem in another "PROBLEM" thread.
>
> [snip]
>
>> I'll look at the patch. Either the EDID is *not* consistent (in which
>> case, why are we not seeing other bugs like this?) or there is something
>> specific to this system or panel used.
>
> Interesting. Or even downright bizarre! Can you disable the caching
> (hopefully the patch is still revertible) and save the EDID
> (/sys/class/drm/card0-LVDS-1/edid) periodically? Might be simplest just to
> dump the EDID every time we probe the LVDS if it has changed.
> -Chris
>

Hi,

I have observed major corruption issues for kernel 2.6.37.
Going back to 2.6.36 stable restores things to normality.
I unfortunately do not have time to track down the problem, but I
thought I would mention it as it could be causing your problem.
My problems were:
Corrupting the library cache so that .so files failed to load any more.
Corrupting .o files during compilation so that the linker did not even
recognize them as .o files.
Corrupted data between a DVB card and the recording on the HD.
I am just mentioning it, because the cause might in fact be somewhere else.

Kind Regards

James
