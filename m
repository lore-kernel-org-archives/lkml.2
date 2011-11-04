Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704Ab1KDA4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 20:56:43 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57656 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab1KDA4l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 20:56:41 -0400
MIME-Version: 1.0
In-Reply-To: <1320204101.31823.140.camel@wwguy-huron>
References: <1319003304.31823.46.camel@wwguy-huron>
	<20111019064628.GA14817@gamma.logic.tuwien.ac.at>
	<1319004836.31823.57.camel@wwguy-huron>
	<20111020045927.GB23044@gamma.logic.tuwien.ac.at>
	<1319119852.2111.2.camel@wwguy-ubuntu>
	<20111021012442.GB26758@gamma.logic.tuwien.ac.at>
	<alpine.DEB.2.00.1110231424500.17218@chino.kir.corp.google.com>
	<20111026025014.GB24956@gamma.logic.tuwien.ac.at>
	<1319601333.14693.19.camel@wwguy-ubuntu>
	<20111026040332.GF24956@gamma.logic.tuwien.ac.at>
	<20111102031345.GA10851@gamma.logic.tuwien.ac.at>
	<1320204101.31823.140.camel@wwguy-huron>
Date: Thu, 3 Nov 2011 20:56:40 -0400
X-Google-Sender-Auth: cjPM1s6HUtEjuXMB3_1fLnMP4dk
Message-ID: <CABDyM6RtCV1=0mgcmsgquFBjx-sDg9ZD5YQEzs_nLmSPLaJdpQ@mail.gmail.com>
Subject: Re: iwlagn is getting very shaky
From: Richard Yao <ryao@cs.stonybrook.edu>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Norbert Preining <preining@logic.at>, David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Wey,

My situation is very similar to Norbert's. At my house, I have no
issues at all, but at my university, I tend to have issues. In the
past, using 11n_disable=1 would cause the wireless interface to break
until I executed "modprobe -r iwlagn && modprobe iwlagn" as root. That
was around Linux 3.0-rc4. I haven't tried it since, but what seems to
help is "iwconfig wlan0 rts 0", but even that is not perfect. I just
gave "modprobe -r iwlagn && modprobe iwlagn 11n_disable=1" another try
and it makes no difference.

Issues with the campus Wi-Fi are not isolated to Linux users. I
suspect it has something to do with the 100 or so access points that I
see when I do "iwlist wlan0 scan" at my university and the 4 that I
see when I do that off campus. I don't want to imagine how many
devices are trying to use the available bandwidth. I imagine that
implementing "auto" for rts would improve both my and Norbert's
situations.

Yours truly,
Richard Yao

On Tue, Nov 1, 2011 at 11:21 PM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
> Hi Norbert,
>
> On Tue, 2011-11-01 at 20:13 -0700, Norbert Preining wrote:
>> Hi all,
>>
>> On Mi, 26 Okt 2011, Norbert Preining wrote:
>> > On Di, 25 Okt 2011, wwguy wrote:
>> > > so this is different problem, right? it looks different compare to what
>> > > you described before which is cause by queue stopped.
>> >
>> > I assume that this is a different regression concerning 3.1.0 released.
>>
>> Is there any progress on that? Currently linux git status is unusable
>> with respect to iwlwifi?
>>
>> Are there any changes planned before rc1?
>>
> after the firmware reloaded, is the traffic resume? or it is continuous
> without traffic?
>
> Looks like the different "queue stuck" problem you are seeing. you
> mention you only seeing this at university but not home. So what the
> differences are?
> what Band/channel you are using, also, if you disable 11n, are you still
> seeing the problem?
>
> you also mention it is might related to suspend/resume, could you please
> give a better description why you think it might be related
>
> Thanks
> Wey
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
