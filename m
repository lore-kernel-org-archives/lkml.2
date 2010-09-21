Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab0IUPtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 11:49:31 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:51069 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab0IUPt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 11:49:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=XatnW+h/J83y5ekYAjXiCPK0ZSBIRhxPP8eZEYUisMtO7XGSC/0axRsnHjgArJ5kwc
         wWm1cyo6vhxzvJikSrkGa8gqzBrlKwIuVin4ZeTTmmYeNlzvNFVQ2UJIr7kO4xnzc+v+
         UHXp4Fvqfu+aTbzIvbkqMglXQzc0wEUo40QVg=
Message-ID: <4C98D403.3090509@gmail.com>
Date: Tue, 21 Sep 2010 08:49:23 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Randy Dunlap <rdunlap@xenotime.net>, Matt Turner <mattst88@gmail.com>,
        Dimitry Torokhov <dmitry.torokhov@gmail.com>,
        Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH v2]Update broken web addresses in the kernel.
References: <1285050654-15188-1-git-send-email-justinmattock@gmail.com> <alpine.LFD.2.00.1009211614590.6717@eddie.linux-mips.org>
In-Reply-To: <alpine.LFD.2.00.1009211614590.6717@eddie.linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2010 08:31 AM, Maciej W. Rozycki wrote:
> On Mon, 20 Sep 2010, Justin P. Mattock wrote:
>
>> Resend: This is an updated patch due to some mistakes that I had made with the original patch.
>> Below you will find a patch containing updates to broken web addresses in the kernel.
>> Some were easy to piece together, but some were knowhere to be found..Keep in mind this was
>> just a grep for "http", not sure how many other protocol's in there are working or not..
>> Note: Thanks to Matt Turner for pointing out that the archive.org address breaks
>> compiling with the "*" in it's url..(thankfully a simple fix provided by Matt "%2A" resolved this).
>> Thanks to everybody giving feedback on this, and let me know if I missed something..
>
>   It has fallen between the cracks, sorry.
>
>   Here's my proposal about the change we discussed before.  It refers to
> HP's mirror of the original archive as well as another mirror run by
> volunteers that happens to include a couple of extra files missing from
> the former for some reason.  Hopefully either of these will stay online
> for the foreseeable future.
>
>   Rather than some Digital Unix specific details these two archives provide
> original TURBOchannel documentation supplied by DEC as a part of their
> 1990s' TriAdd initiative.  Included are hardware- and software-level
> TURBOchannel specifications suitable for use by hardware designers and
> firmware and OS developers respectively, as well as a number of additional
> related documents.  While not strictly related, there's Access.Bus
> documentation too.
>
>   Then the linux-mips.org Wiki page documents Linux driver support (or the
> lack of) for many TURBOchannel option cards -- while the page is specific
> to the DECstation, the drivers are generic enough to work with any Linux
> platform supporting TURBOchannel -- apart from the MIPS-based DECstation,
> there are Alpha- and VAX-based TURBOchannel systems in existence we may
> eventually add support for in Linux one day.  I still do hope to add some
> more drivers to this page sometime too. :)
>
>   Thanks again for working on this.
>
> Signed-off-by: Maciej W. Rozycki<macro@linux-mips.org>
> ---
> patch-mips-2.6.36-rc4-20100921-tc-doc-0
> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> index 5526faa..b4759db 100644
> --- a/arch/mips/Kconfig
> +++ b/arch/mips/Kconfig
> @@ -2192,10 +2192,14 @@ config TC
>   	bool "TURBOchannel support"
>   	depends on MACH_DECSTATION
>   	help
> -	  TurboChannel is a DEC (now Compaq (now HP)) bus for Alpha and MIPS
> -	  processors.  Documentation on writing device drivers for TurboChannel
> -	  is available at:
> -	<http://www.cs.arizona.edu/computer.help/policy/DIGITAL_unix/AA-PS3HD-TET1_html/TITLE.html>.
> +	  TURBOchannel is a DEC (now Compaq (now HP)) bus for Alpha and MIPS
> +	  processors.  TURBOchannel programming specifications are available
> +	  at:
> +	<ftp://ftp.hp.com/pub/alphaserver/archive/triadd/>
> +	  and:
> +	<http://www.computer-refuge.org/classiccmp/ftp.digital.com/pub/DEC/TriAdd/>
> +	  Linux driver support status is documented at:
> +	<http://www.linux-mips.org/wiki/DECstation>
>
>   #config ACCESSBUS
>   #	bool "Access.Bus support"
>


cool thanks for this.. I'll add the change..

Justin P. Mattock
