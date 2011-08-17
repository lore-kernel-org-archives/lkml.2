Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab1HQTQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 15:16:43 -0400
Received: from lucidpixels.com ([72.73.18.11]:44901 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753297Ab1HQTQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 15:16:41 -0400
Date: Wed, 17 Aug 2011 15:16:40 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Jeff Layton <jlayton@samba.org>
cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS (also crashes
 with linux-3.1-rc2
In-Reply-To: <alpine.DEB.2.02.1108151357200.32349@p34.internal.lan>
Message-ID: <alpine.DEB.2.02.1108171515050.5877@p34.internal.lan>
References: <alpine.DEB.2.02.1108150506310.7571@p34.internal.lan> <alpine.LNX.2.00.1108151117480.19668@swampdragon.chaosbits.net> <20110815064734.403b630f@corrin.poochiereds.net> <alpine.DEB.2.02.1108150653200.7571@p34.internal.lan>
 <alpine.DEB.2.02.1108151357200.32349@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 15 Aug 2011, Justin Piszcz wrote:

>
>
> On Mon, 15 Aug 2011, Justin Piszcz wrote:
>
>> On Mon, 15 Aug 2011, Jeff Layton wrote:
>>

Hi,

Tried with linux-3.1-rc2 and:

You don't even need to get a successful mount:

Does anyone know if any kernel supports CIFS w/out crashing? I'd like to 
backup some CIFS shares, thanks.


mount -t cifs //w2/x /mnt -o user=user,pass=pass

[  881.388836] CIFS VFS: cifs_mount failed w/return code = -22
Message from syslogd@acerlw at Aug 17 15:14:11 ...
  kernel:[  903.639362] ------------[ cut here ]------------

Message from syslogd@acerlw at Aug 17 15:14:11 ...
  kernel:[  903.639380] invalid opcode: 0000 [#1] SMP

Message from syslogd@acerlw at Aug 17 15:14:11 ...
  kernel:[  903.639540] Stack:

Message from syslogd@acerlw at Aug 17 15:14:11 ...
  kernel:[  903.639573] Call Trace:

Message from syslogd@acerlw at Aug 17 15:14:11 ...
  kernel:[  903.639649] Code: 00 e9 d2 00 00 00 49 8b 07 49 39 c7 75 15 49 8b 47 20 41 c7 47 60 01 00 00 00 4c 39 d0 0f 84 ad 00 00 00 8b 53 18 39 50 20 72 2f <0f> 0b 44 8b 40 24 8b 53 0c ff c6 41 8b 3c 24 89 70 20 41 0f af

Message from syslogd@acerlw at Aug 17 15:14:20 ...
  kernel:[  912.901194] Oops: 0002 [#2] SMP

Message from syslogd@acerlw at Aug 17 15:14:20 ...
  kernel:[  912.901343] Stack:

Message from syslogd@acerlw at Aug 17 15:14:20 ...
  kernel:[  912.901375] Call Trace:

Message from syslogd@acerlw at Aug 17 15:14:20 ...
  kernel:[  912.901516] Code: e8 3b fd ff ff 48 8b 43 58 2a 43 50 88 43 4e eb e9 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 48 89 f8 89 d1 c1 e9 03 83 e2 07 <f3> 48 a5 89 d1 f3 a4 c3 20 48 83 ea 20 4c 8b 06 4c 8b 4e 08 4c

Message from syslogd@acerlw at Aug 17 15:14:20 ...
  kernel:[  912.901590] CR2: 0000000000000200

Message from syslogd@acerlw at Aug 17 15:15:12 ...
  kernel:[  906.705093] Stack:

Message from syslogd@acerlw at Aug 17 15:15:12 ...
  kernel:[  906.705093] Call Trace:

Message from syslogd@acerlw at Aug 17 15:15:12 ...
  kernel:[  906.705093] Code: f0 66 0f c1 17 38 f2 74 06 f3 90 8a 17 eb f6 c3 0f 1f 84 00 00 00 00 00 fa b8 00 01 00 00 f0 66 0f c1 07 38 e0 74 06 f3 90 8a 07 <eb> f6 c3 66 2e 0f 1f 84 00 00 00 00 00 fe 07 56 9d f7 c6 00 02

Message from syslogd@acerlw at Aug 17 15:15:12 ...
  kernel:[  905.287886] Stack:

Message from syslogd@acerlw at Aug 17 15:15:12 ...
  kernel:[  905.287886] Call Trace:

Message from syslogd@acerlw at Aug 17 15:15:12 ...
  kernel:[  905.287886] Code: 94 c2 0f b6 c2 85 c0 0f 95 c0 0f b6 c0 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 b8 00 01 00 00 f0 66 0f c1 07 38 e0 74 06 <f3> 90 8a 07 eb f6 c3 66 66 2e 0f 1f 84 00 00 00 00 00 9c 58 fa

Message from syslogd@acerlw at Aug 17 15:15:12 ...
  kernel:[  965.289061] Stack:

Message from syslogd@acerlw at Aug 17 15:15:12 ...
  kernel:[  965.289061] Call Trace:

Message from syslogd@acerlw at Aug 17 15:15:12 ...
  kernel:[  965.289061] Code: 66 66 2e 0f 1f 84 00 00 00 00 00 65 48 8b 04 25 08 b6 00 00 83 a0 3c e0 ff ff fb 0f ae f0 48 8b 80 38 e0 ff ff a8 08 75 13 fb f4

Message from syslogd@acerlw at Aug 17 15:15:12 ...
  kernel:[  965.289082] Stack:

Message from syslogd@acerlw at Aug 17 15:15:12 ...
  kernel:[  965.289082] Call Trace:

Message from syslogd@acerlw at Aug 17 15:15:12 ...
  kernel:[  965.289082]  <IRQ>

Message from syslogd@acerlw at Aug 17 15:15:12 ...
  kernel:[  965.289082]  <EOI>

Message from syslogd@acerlw at Aug 17 15:15:12 ...
  kernel:[  965.289082] Code: 00 00 00 48 ff c8 75 fb 48 ff c8 c3 0f 1f 80 00 00 00 00 48 8b 05 71 c3 96 00 ff e0 0f 1f 80 00 00 00 00 48 8d 04 bd 00 00 00 00


Justin.

