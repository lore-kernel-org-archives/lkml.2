Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab0LIB3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 20:29:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49266 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375Ab0LIB3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 20:29:16 -0500
Message-ID: <4D00308B.2040009@zytor.com>
Date: Wed, 08 Dec 2010 17:27:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jack Steiner <steiner@sgi.com>
CC: lenb@kernel.org, hmh@hmh.eng.br, mingo@elte.hu, tglx@linutronix.de,
        tony.luck@gmail.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, gbeshers@sgi.com
Subject: Re: [RFC  - V2] - Mapping ACPI tables as CACHED
References: <20100722152220.GA18290@sgi.com> <20100724001449.GA9618@khazad-dum.debian.net> <4C743C0F.2010101@zytor.com> <20100826171704.GA21584@sgi.com> <4C76AD82.2030105@zytor.com> <20101208212244.GA24280@sgi.com>
In-Reply-To: <20101208212244.GA24280@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2010 01:22 PM, Jack Steiner wrote:
> 
> This patch substantially reduces the time to run ACPIDUMP on a large system:
>  	527 seconds without the patch
>  	  8 seconds with the patch
> 

This is probably the worst possible motivation you can give here.
Bootup time is much more of an issue.

However, this really needs Len's ack.

	-hpa
