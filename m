Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964924Ab2JCPvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:51:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39705 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932427Ab2JCPvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:51:13 -0400
Message-ID: <506C5EDB.9000107@zytor.com>
Date: Wed, 03 Oct 2012 08:50:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Daniel Blueman <daniel@numascale-asia.com>
CC: Ingo Molnar <mingo@redhat.com>, Steffen Persvold <sp@numascale.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@amd64.org>, x86@kernel.org
Subject: Re: [PATCH] RFC: Fix AMD Northbridge-ID contiguity assumptions
References: <1349256029-14851-1-git-send-email-daniel@numascale-asia.com> <506C56B2.50505@zytor.com> <CAP-4_fVhkjb=0YdYz37PEg3Or-hbRO8F40tHqEsRCC-pYY_HOg@mail.gmail.com>
In-Reply-To: <CAP-4_fVhkjb=0YdYz37PEg3Or-hbRO8F40tHqEsRCC-pYY_HOg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 08:30 AM, Daniel Blueman wrote:
>  >
>  > Is that "on NumaScale systems"?  If so, please say so rather than trying
>  > to make it sound generic; if it is not, can you give some other examples?
>
> It is for Numascale (NumaChip) systems for our purposes.
>
> Any other systems which interconnect Opterons via address space routing
> (needed for >8 HT nodes) will get this benefit. I can't put my hand to
> exactly what is out there, but can find out.
>

The reason I'm asking is because it is an important bit of the record of 
the code to know if this is a specific need or a general need.  This may 
be obvious now, but 5-10 years from now someone will need to know why or 
what.

The two paragraphs above is exactly what is needed, i.e. "NumaChip or 
any other design which shares these specific design features: ..."

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

