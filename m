Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383Ab2DPGNC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 02:13:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41871 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892Ab2DPGNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 02:13:00 -0400
Message-ID: <4F8BB814.1090607@zytor.com>
Date: Sun, 15 Apr 2012 23:11:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Pedro Alves <palves@redhat.com>
CC: Nick Bowler <nbowler@elliptictech.com>, Jiri Slaby <jslaby@suse.cz>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>, apw@canonical.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] checkpatch.pl: thou shalt not use () or (...) in
 function declarations
References: <1332430038-21057-1-git-send-email-ext-phil.2.carmody@nokia.com> <4F6B51C9.6010904@suse.cz> <20120322171702.GA27776@elliptictech.com> <4F703F06.60709@redhat.com>
In-Reply-To: <4F703F06.60709@redhat.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2012 03:03 AM, Pedro Alves wrote:
> On 03/22/2012 05:17 PM, Nick Bowler wrote:
> 
>> GCC will not normally warn about the above (unless you pass
>> -Wold-style-definition) which warns for all function definitions that
>> lack a prototype.
> 
> 
> /me asks the stupid question:
> 
> Why not make the compiler catch this instead then, with -Werror=old-style-definition?
> 

Sounds like a good thing to do.

	-hpa

