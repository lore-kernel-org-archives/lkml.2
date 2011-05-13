Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890Ab1EMULx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 16:11:53 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56526 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab1EMULv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 16:11:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=uNt4dEZIygHcsmHnC8brOhxKymOpW9Hvkwm24othlzFEtNekmA3VLwUbp9SPENky9/
         bjsULd4sTVQcTpjR0+0QIL4SDsFOfnH/kp8y5N1aI45sqmfUboUd7ni30oQB8NEFUOnx
         b0Dj5y7OwGzxEkAA/qsdPUMaTq8M4bcHi3XaM=
Message-ID: <4DCD907E.6040101@gmail.com>
Date: Fri, 13 May 2011 22:11:42 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Wim Heirman <wim@heirman.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: perf-stat per thread results
References: <BANLkTimTOTz4qNwYPa6Ey7=QRjOhQHWt-Q@mail.gmail.com>
In-Reply-To: <BANLkTimTOTz4qNwYPa6Ey7=QRjOhQHWt-Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/13/2011 05:14 PM, Wim Heirman wrote:
> Hi all,
>
> I'm using perf-stat to look at hardware performance counters for a
> parallel program. Is there a way to get counter values for each thread
> individually, rather than aggregated for the whole process? I know I
> can attach to a specific thread using --tid=, but due to the time
> required to find the tid and attach/detach this isn't accurate for
> short-running programs.
> Or, alternatively, can I use perf record --stat and get an exact count
> for each performance counter?
>

What about using PAPI library (http://icl.cs.utk.edu/papi/)?
It can be built on top of the perf subsystem and allows to get counters 
values on a pre-thread basis.
I used it for some experiments and works very well.

Cheers,
	Juri

-- 
Juri Lelli
Via G. Moruzzi 1, 56124 Pisa (PI), Italy
Scuola Superiore Sant'Anna
TeCIP, ReTiS Lab

Web Site: http://retis.sssup.it/~jlelli | Skype: jurile2712
-------------------------------------------------------------
Il male minore non esiste: è sempre il preannuncio di un male peggiore.
							(Sylos Labini)
