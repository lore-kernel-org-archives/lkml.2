Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab0JEUCG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 16:02:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55244 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640Ab0JEUCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 16:02:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Yl4to2NSLTDlIqPNDnRlAmcmsUZKvKCG/P1f5Y1CLCCLg+1zsJJOQEE8xI7EERjTsz
         3/a3u8B/VOzA3PgXsyEtM98NCbcXTqmoFgPR2tnrHFlPhYfbKnQtgbd/9iOIT5sL+DmB
         H7G15CtwqZkReif6LWLiCEohFEcjnalY5nWzU=
MIME-Version: 1.0
In-Reply-To: <27F9C60D11D683428E133F85D2BB4A5304681D4889@dlee03.ent.ti.com>
References: <1286208555-8829-1-git-send-email-felipe.contreras@gmail.com>
	<20101005190741.GC20825@kroah.com>
	<AANLkTikOBWxXh7uVrDxfW3OnwOM58JTXU76KUUoQWBWM@mail.gmail.com>
	<27F9C60D11D683428E133F85D2BB4A5304681D4889@dlee03.ent.ti.com>
Date: Tue, 5 Oct 2010 23:02:02 +0300
Message-ID: <AANLkTin=k07hUq+cLAOsf0aYw5Ey23UOpbpo=+Eb49w9@mail.gmail.com>
Subject: Re: [PATCH 0/2] omap: dsp: make the driver actually work
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
Cc: Greg KH <greg@kroah.com>, linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Hiroshi Doyu <hiroshi.doyu@nokia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 5, 2010 at 10:52 PM, Ramirez Luna, Omar <omar.ramirez@ti.com> wrote:
> Felipe Contreras wrote:
> ...
>>
>> Well, I thought it would be nice if the driver actually worked on
>> .36, but anyway, I'll rebase the rest of my cleanup patches and send
>> them. Hopefully I find a way to get rid of the ioremap() issue.
>>
>
> phys_to_virt instead of ioremap should work fine, still need to try it though.

I tried that... Didn't work. I guess we need to flush at some points
(since the memory is cacheable).

-- 
Felipe Contreras
