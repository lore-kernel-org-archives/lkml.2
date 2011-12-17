Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760868Ab1LQD2p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 22:28:45 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52610 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab1LQD2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 22:28:39 -0500
Message-ID: <1324092514.2621.49.camel@edumazet-laptop>
Subject: Re: Memory corruption warnings triggered by repeated slabinfo -v
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alex =?ISO-8859-1?Q?Villac=EDs?= Lasso <a_villacis@palosanto.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Sat, 17 Dec 2011 04:28:34 +0100
In-Reply-To: <4EEBFAF3.60609@palosanto.com>
References: <4EEBFAF3.60609@palosanto.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 16 décembre 2011 à 21:14 -0500, Alex Villacís Lasso a
écrit :
> I am running Fedora 16 x86_64 and testing vanilla kernel 3.2-rc5. I 
> wanted to test the slabinfo program, so I wrote a small shell script 
> slabinfo-forever.sh (attached) that invokes slabinfo -v every 3 seconds. 
> Just by doing this, I was able to trigger several memory validation 
> warnings, attached in this message. The reason I wanted to test slabinfo 
> is because back when I was running Fedora 14, I had some video issues 
> that seemed consistent with memory corruption. I tried to submit a 
> kernel bug at https://bugzilla.kernel.org/show_bug.cgi?id=42312 just 
> before the kernel.org hack issue, but bugzilla.kernel.org never came up 
> after that.

Problem is known and fixes were submitted.


