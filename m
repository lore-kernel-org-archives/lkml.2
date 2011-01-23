Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab1AWCpU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 21:45:20 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44896 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab1AWCpT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 21:45:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=aa6toWaZBGoM8YUofYCG08bo+HZTgXoF16VZqv4NkDmuiY0q/WX98vowf8NnjPSAiA
         Oxe+nmbb8FzizQROLnTbN0WfNE4tlYZSaG3MFTADYzh0uLOHnU0iYhDthe+vHUbFXWhS
         kXthUEl2WETmYnnxsMhGanntDijwVx+6FmN0E=
MIME-Version: 1.0
In-Reply-To: <20101220182242.GA29696@srcf.ucam.org>
References: <AANLkTikaxPEszPPU=J1bP2TitrrDuhZ=FZKbD2hwD+VH@mail.gmail.com> <20101220182242.GA29696@srcf.ucam.org>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sat, 22 Jan 2011 21:44:58 -0500
X-Google-Sender-Auth: 6j1IxwODqwrNN4UjWd70TN1PIhE
Message-ID: <AANLkTi=NdeULK9q=i3vRmtWPD-0gJV1v_2_LgY1YWFZN@mail.gmail.com>
Subject: Re: 2.6.36.2 regression: suspend on Lenovo X200s broken due to TPM
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 1:22 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Mon, Dec 20, 2010 at 01:10:03PM -0500, Andrew Lutomirski wrote:
>> The change "PNPACPI: cope with invalid device IDs", added in 2.6.36.2,
>> makes the kernel detect my TPM (it used to not work at all), but the
>> TPM driver doesn't work because it can't autodetect the iTPM
>> workaround.  This breaks suspend without actually fixing my TPM.
>
> I hadn't realised that patch went back to stable. Greg, you'll want to
> pull 3f0d3d016d89a5efb8b926d4707eb21fa13f3d27 as well.

Greg, did this get lost for 2.6.36.3?

--Andy
