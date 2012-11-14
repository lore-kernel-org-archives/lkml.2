Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab2KNALG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 19:11:06 -0500
Received: from spam1.webland.se ([91.207.112.90]:62028 "EHLO spam1.webland.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756054Ab2KNALF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 19:11:05 -0500
From: Arvid Brodin <Arvid.Brodin@xdin.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "David Rientjes" <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] fs/proc: Add process text segment md5-summing
Thread-Topic: [PATCH] fs/proc: Add process text segment md5-summing
Thread-Index: AQHNwSnrqn3lr7PkbEaV3fGGkgsdL5foZfSA
Date: Wed, 14 Nov 2012 00:11:01 +0000
Message-ID: <50A2E193.5090905@xdin.com>
References: <50A16BD0.7030600@xdin.com>
 <20121112150325.2516a0bf.akpm@linux-foundation.org>
In-Reply-To: <20121112150325.2516a0bf.akpm@linux-foundation.org>
Accept-Language: sv-SE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20120410
 Thunderbird/8.0
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <53F0FCC886C3074281F5354CEF68DCCF@redbull.xdin.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-13 00:03, Andrew Morton wrote:
> On Mon, 12 Nov 2012 21:36:17 +0000
> Arvid Brodin <Arvid.Brodin@xdin.com> wrote:
> 
>> Adds /proc/<pid>/text_md5sum which, when read, calculates an md5sum over
>> the process' text segment. This can detect some cases where the system RAM
>> has been disturbed by e.g. ESD or cosmic radiation (on systems where ECC
>> is not available). It might also detect some accidental or malicious
>> modifications of executables, where the perpetrator has not bothered to
>> cover up the tracks.
> 
> I thought the review comments regarding the earlier patch were rather
> fatal, sorry.

Ok. I get the point now at least. :) Thanks for taking the time to comment
on this!

-- 
Arvid Brodin | Consultant (Linux)
XDIN AB | Knarrarnäsgatan 7 | SE-164 40 Kista | Sweden | xdin.com