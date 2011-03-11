Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab1CKMXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 07:23:41 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36415 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab1CKMXk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 07:23:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YBYxir4iJ7bkaO83mS1cgPCAexGkwWeL8LTrlqusbSQqnEuoEfRK4mEMJE74bLzamT
         xGCM3X9J/ejUsr7l5AY+0J/a5/NbN6AkU3mlGnO3mka9Q51Yi4TTwfxd9M15Jf/vQOvW
         OsR9VuJvp/fL5tiU2YddKIzhDPCMJvvU9/pd8=
MIME-Version: 1.0
In-Reply-To: <20110311121704.GF1760@opensource.wolfsonmicro.com>
References: <1299703580-3957-1-git-send-email-marek.belisko@open-nandra.com>
	<20110311121704.GF1760@opensource.wolfsonmicro.com>
Date: Fri, 11 Mar 2011 13:23:37 +0100
Message-ID: <AANLkTintYQ=qO3PALBL-bkiYKQFw0+JiW3=-oZmkRhZ1@mail.gmail.com>
Subject: Re: [PATCH RFC] arm: mini2440: Fix uda134x codec problem.
From: Belisko Marek <marek.belisko@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: ben-linux@fluff.org, perex@perex.cz, tiwai@suse.de, lrg@slimlogic.co.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 1:17 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Mar 09, 2011 at 09:46:20PM +0100, Marek Belisko wrote:
>> ASoC audio for mini2440 platform in current kenrel doesn't work.
>> First problem is samsung_asoc_dma device is missing in initialization.
>> Next problem is with codec. Codec is initialized but never probed
>
> Applied, thanks.  With changes like this you should really split things
> up into a small patch series - if you ever find yourself writing
> "Next problem..." or "Also..." then going on to describe a separate
> change that's a sign that you should be writing a separate patch.
You're right. I think sending whole patch to help understand what
I'm trying to do (because wasn't sure). You apply just asoc part right?
Thanks for comments!
>

regards,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
icq: 290551086
web: http://open-nandra.com
