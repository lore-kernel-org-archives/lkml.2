Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750949Ab1EZESU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 00:18:20 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47657 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab1EZEST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 00:18:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=DxDSCk3EWrnGySyV1pBRujySueR/Rg0+ppPYj0Pgk2oiYLU0jbbG/Pn4HabhhsWAAk
         oR7FvouhylKXMIeGHxrdcNlZTLLj39D3O2w4bxizyYD/7FN5DNRO4U41iljtTdjWesQb
         ZWcti0hfHTDPVHuD7DsaA10aHXSEnToc5UZ9I=
Message-ID: <4DDDD47C.5030504@gmail.com>
Date: Wed, 25 May 2011 21:18:04 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: no sound in current -git
References: <20110526013423.GA25226@redhat.com>
In-Reply-To: <20110526013423.GA25226@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2011 06:34 PM, Dave Jones wrote:
> Since the last ALSA merge, I have no sound on my laptop.
> I have onboard intel sound, and a NuForce µDAC. Neither of them show up
> in alsamixer, or pavucontrol.
>
> Is this a clue ?
>
>   ALSA sound/usb/mixer.c:803: 3:0: cannot get min/max values for control 2 (id 3)
>
> 59bb7f0eebe69aa32a5c7917a23a7da1c5667d73 perhaps ?
>
> 	Dave
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


sound over here is out as well on a macbook pro. seems gnome shell 
didn't like whats being merged with the current Mainline i.g. no sound 
bluetooth applet missing. will bisect when I get a chance.

Justin P. Mattock
